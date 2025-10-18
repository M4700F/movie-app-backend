package org.example.movieappbackend.services.impl;

import lombok.extern.slf4j.Slf4j;
import org.example.movieappbackend.entities.Movie;
import org.example.movieappbackend.entities.Recommendation;
import org.example.movieappbackend.entities.User;
import org.example.movieappbackend.exceptions.ResourceNotFoundException;
import org.example.movieappbackend.payloads.MovieRecommendationDto;
import org.example.movieappbackend.payloads.RecommendationResponseDto;
import org.example.movieappbackend.repositories.MovieRepo;
import org.example.movieappbackend.repositories.RecommendationRepo;
import org.example.movieappbackend.services.RecommendationCacheService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Slf4j
public class RecommendationCacheServiceImpl implements RecommendationCacheService {

    @Autowired
    private RecommendationRepo recommendationRepo;

    @Autowired
    private MovieRepo movieRepo;

    @Value("${recommendation.cache.hours:24}")
    private int cacheHours;

    @Override
    @Transactional
    public void saveRecommendationsToCache(Long userId, RecommendationResponseDto mlRecommendations) {
        log.info("Saving recommendations to cache for user {}", userId);

        // Clear old cached recommendations
        recommendationRepo.deleteAllByUserId(userId);

        List<Recommendation> recommendations = new ArrayList<>();

        for (MovieRecommendationDto mlRec : mlRecommendations.getRecommendations()) {
            Optional<Movie> movieOpt = movieRepo.findById(mlRec.getMovieId().longValue());

            if (movieOpt.isEmpty()) {
                log.warn("Movie {} not found in database", mlRec.getMovieId());
                continue;
            }

            User user = new User();
            user.setId(userId);

            Recommendation rec = new Recommendation();
            rec.setUser(user);
            rec.setMovie(movieOpt.get());
            rec.setPredictedScore(mlRec.getPredictedScore());
            rec.setCachedAt(LocalDateTime.now());

            recommendations.add(rec);
        }

        recommendationRepo.saveAll(recommendations);
        log.info("Saved {} recommendations to cache for user {}", recommendations.size(), userId);
    }

    @Override
    public RecommendationResponseDto getCachedRecommendations(Long userId) {
        log.info("Fetching cached recommendations for user: {}", userId);

        List<Recommendation> cached = recommendationRepo.findByUserIdOrderByPredictedScoreDesc(userId);

        if (cached.isEmpty()) {
            log.warn("No cached recommendations found for user {}", userId);
            return null; // Let main service handle fallback
        }

        List<MovieRecommendationDto> recDTOs = cached.stream()
                .map(rec -> new MovieRecommendationDto(
                        rec.getMovie().getId().intValue(),
                        rec.getPredictedScore(),
                        rec.getMovie().getTitle(),
                        rec.getMovie().getGenres()
                ))
                .collect(Collectors.toList());

        RecommendationResponseDto response = new RecommendationResponseDto();
        response.setUserId(userId.intValue());
        response.setRecommendations(recDTOs);

        return response;
    }

    @Override
    public boolean isCacheValid(Long userId) {
        List<Recommendation> cachedRecs = recommendationRepo.findByUserId(userId);

        if (cachedRecs.isEmpty()) {
            log.info("No cached recommendations found for user {}", userId);
            return false;
        }

        // Check the timestamp of the first cached recommendation
        LocalDateTime cachedAt = cachedRecs.get(0).getCachedAt();
        if (cachedAt == null) {
            log.info("Cached recommendations for user {} have no timestamp — invalidating cache", userId);
            return false;
        }

        long hoursSinceCached = Duration.between(cachedAt, LocalDateTime.now()).toHours();
        boolean valid = hoursSinceCached < cacheHours; // cacheHours = e.g. 24

        log.info("Cache for user {} valid: {} ({} hours old)", userId, valid, hoursSinceCached);

        return valid;
    }
}
