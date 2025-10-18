package org.example.movieappbackend.services.impl;

import lombok.extern.slf4j.Slf4j;
import org.example.movieappbackend.entities.Movie;
import org.example.movieappbackend.entities.Rating;
import org.example.movieappbackend.entities.Recommendation;
import org.example.movieappbackend.entities.User;
import org.example.movieappbackend.payloads.*;
import org.example.movieappbackend.repositories.MovieRepo;
import org.example.movieappbackend.repositories.RatingRepo;
import org.example.movieappbackend.repositories.RecommendationRepo;
import org.example.movieappbackend.services.RecommendationCacheService;
import org.example.movieappbackend.services.RecommendationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import java.util.*;
import java.util.stream.Collectors;

@Service
@Slf4j
public class RecommendationServiceImpl implements RecommendationService {
    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    private RatingRepo ratingRepo;

    @Autowired
    private MovieRepo movieRepo;

    @Autowired
    private RecommendationCacheService recommendationCacheService;

    @Value("${fastapi.base-url}")
    private String fastApiBaseUrl;


    @Override
    public RecommendationResponseDto getRecommendationsForUser(Long userId) {
        log.info("Getting recommendations for user: {}", userId);

        // ✅ Step 1: Check if cached recommendations exist and are still valid
        if (recommendationCacheService.isCacheValid(userId)) {
            log.info("Returning cached recommendations for user {}", userId);
            return recommendationCacheService.getCachedRecommendations(userId);
        }

        // Get user's ratings
        List<Rating> userRatings = ratingRepo.findByUserId(userId);

        if (userRatings.isEmpty()) {
            log.info("User {} has no ratings, returning popular movies", userId);
            return getPopularMoviesAsRecommendations(userId);
        }

        // Call FastAPI
        try {
            // Convert ratings to DTO
            List<UserRatingDto> ratingDTOs = userRatings.stream()
                    .map(r -> new UserRatingDto(
                            r.getMovie().getId().intValue(),
                            r.getScore()
                    ))
                    .collect(Collectors.toList());

            RecommendationRequestDto request = new RecommendationRequestDto();
            request.setUserId(userId.intValue());
            request.setUserRatings(ratingDTOs);
            request.setTopN(10);

            String url = fastApiBaseUrl + "/recommend";

            log.info("Calling FastAPI at: {}", url);
            ResponseEntity<RecommendationResponseDto> response = restTemplate.postForEntity(
                    url,
                    request,
                    RecommendationResponseDto.class
            );

            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                log.info("Successfully got {} recommendations from FastAPI",
                        response.getBody().getRecommendations().size());

                // Save recommendations to cache
                this.recommendationCacheService.saveRecommendationsToCache(userId, response.getBody());

                return response.getBody();
            }

        } catch (Exception e) {
            log.error("Error calling FastAPI for user {}: {}", userId, e.getMessage());
            // Fallback to cached recommendations
            return this.recommendationCacheService.getCachedRecommendations(userId);
        }

        return getPopularMoviesAsRecommendations(userId);
    }

    /**
     * Get recommendations for new user based on genre preferences
     */
    @Override
    public RecommendationResponseDto getRecommendationsForNewUser(Long userId, NewUserPreferencesDto preferencesDto) {
        log.info("Getting recommendations for new user: {}", userId);

        try {
            RecommendationRequestDto request = new RecommendationRequestDto();
            request.setUserId(userId.intValue());
            request.setNewUserPreferences(preferencesDto);
            request.setTopN(10);

            String url = fastApiBaseUrl + "/recommend";

            ResponseEntity<RecommendationResponseDto> response = restTemplate.postForEntity(
                    url,
                    request,
                    RecommendationResponseDto.class
            );

            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                log.info("Successfully got recommendations for new user");
                return response.getBody();
            }

        } catch (Exception e) {
            log.error("Error getting recommendations for new user: {}", e.getMessage());
        }

        return getPopularMoviesAsRecommendations(userId);
    }



    @Override
    public RecommendationResponseDto getPopularMoviesAsRecommendations(Long userId) {
        log.info("Returning popular movies for user: {}", userId);

        List<Movie> popularMovies = movieRepo.findTop10Movies();

        List<MovieRecommendationDto> recDTOs = popularMovies.stream()
                .map(movie -> new MovieRecommendationDto(
                        movie.getId().intValue(),
                        4.0, // Default score
                        movie.getTitle(),
                        movie.getGenres()
                ))
                .collect(Collectors.toList());

        RecommendationResponseDto response = new RecommendationResponseDto();
        response.setUserId(userId.intValue());
        response.setRecommendations(recDTOs);

        return response;
    }

    @Override
    public List<MovieRecommendationDto> getSimilarMovies(Long movieId, int topN) {
        log.info("Getting similar movies for movie: {}", movieId);
        try {
            String url = fastApiBaseUrl + "/similar-movies/" + movieId + "?top_n=" + topN;

            ResponseEntity<Map> response = restTemplate.getForEntity(url, Map.class);

            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                List<Map<String, Object>> similarMovies =
                        (List<Map<String, Object>>) response.getBody().get("similar_movies");

                return similarMovies.stream()
                        .map(movie -> new MovieRecommendationDto(
                                (Integer) movie.get("movie_id"),
                                (Double) movie.get("similarity_score"),
                                (String) movie.get("title"),
                                (String) movie.get("genres")
                        ))
                        .collect(Collectors.toList());
            }

        } catch (Exception e) {
            log.error("Error getting similar movies: {}", e.getMessage());
        }

        return Collections.emptyList();
    }
}
