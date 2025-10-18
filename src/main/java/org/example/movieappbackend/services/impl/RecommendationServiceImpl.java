package org.example.movieappbackend.services.impl;

import lombok.extern.slf4j.Slf4j;
import org.example.movieappbackend.entities.Movie;
import org.example.movieappbackend.entities.Rating;
import org.example.movieappbackend.payloads.*;
import org.example.movieappbackend.repositories.MovieRepo;
import org.example.movieappbackend.repositories.RatingRepo;
import org.example.movieappbackend.services.RecommendationCacheService;
import org.example.movieappbackend.services.RecommendationService;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
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
    private ModelMapper modelMapper;

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

            // ✅ Use Map to handle FastAPI response flexibly
            ResponseEntity<Map> response = restTemplate.postForEntity(
                    url,
                    request,
                    Map.class
            );

            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                List<Map<String, Object>> recommendations =
                        (List<Map<String, Object>>) response.getBody().get("recommendations");

                if (recommendations != null && !recommendations.isEmpty()) {
                    // Extract movie IDs and enrich with database data
                    List<MovieDto> enrichedMovies = recommendations.stream()
                            .map(rec -> {
                                Integer movieId = (Integer) rec.get("movie_id");
                                if (movieId == null) {
                                    movieId = (Integer) rec.get("movieId");
                                }
                                return movieId != null ? movieId.longValue() : null;
                            })
                            .filter(Objects::nonNull)
                            .map(movieId -> movieRepo.findById(movieId)
                                    .map(movie -> modelMapper.map(movie, MovieDto.class))
                                    .orElse(null))
                            .filter(Objects::nonNull)
                            .collect(Collectors.toList());

                    RecommendationResponseDto dto = new RecommendationResponseDto(
                            userId.intValue(),
                            enrichedMovies
                    );

                    this.recommendationCacheService.saveRecommendationsToCache(userId, dto);

                    return dto;
                }
            }

        } catch (Exception e) {
            log.error("Error calling FastAPI for user {}: {}", userId, e.getMessage());
            e.printStackTrace(); // Add this temporarily for debugging
            // Fallback to cached recommendations
            RecommendationResponseDto cached = this.recommendationCacheService.getCachedRecommendations(userId);
            if (cached != null) {
                return cached;
            }
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

            // ✅ Use Map to handle FastAPI response flexibly
            ResponseEntity<Map> response = restTemplate.postForEntity(
                    url,
                    request,
                    Map.class
            );

            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                List<Map<String, Object>> recommendations =
                        (List<Map<String, Object>>) response.getBody().get("recommendations");

                if (recommendations != null && !recommendations.isEmpty()) {
                    // Extract movie IDs and enrich with database data
                    List<MovieDto> enrichedMovies = recommendations.stream()
                            .map(rec -> {
                                Integer movieId = (Integer) rec.get("movie_id");
                                if (movieId == null) {
                                    movieId = (Integer) rec.get("movieId");
                                }
                                return movieId != null ? movieId.longValue() : null;
                            })
                            .filter(Objects::nonNull)
                            .map(movieId -> movieRepo.findById(movieId)
                                    .map(movie -> modelMapper.map(movie, MovieDto.class))
                                    .orElse(null))
                            .filter(Objects::nonNull)
                            .collect(Collectors.toList());

                    return new RecommendationResponseDto(userId.intValue(), enrichedMovies);
                }
            }

        } catch (Exception e) {
            log.error("Error getting recommendations for new user: {}", e.getMessage());
            e.printStackTrace(); // Add this temporarily for debugging
        }

        return getPopularMoviesAsRecommendations(userId);
    }



    @Override
    public RecommendationResponseDto getPopularMoviesAsRecommendations(Long userId) {
        log.info("Returning popular movies for user: {}", userId);

        List<Movie> popularMovies = movieRepo.findTop10Movies();

        // Already have full Movie entities, so posterUrl is included
        List<MovieDto> movieDtos = popularMovies.stream()
                .map(movie -> modelMapper.map(movie, MovieDto.class))
                .collect(Collectors.toList());

        return new RecommendationResponseDto(userId.intValue(), movieDtos);
    }

    @Override
    public List<MovieDto> getSimilarMovies(Long movieId, int topN) {
        log.info("Getting similar movies for movie: {}", movieId);
        try {
            String url = fastApiBaseUrl + "/similar-movies/" + movieId + "?top_n=" + topN;

            ResponseEntity<Map> response = restTemplate.getForEntity(url, Map.class);

            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                List<Map<String, Object>> similarMovies =
                        (List<Map<String, Object>>) response.getBody().get("similar_movies");

                if (similarMovies != null && !similarMovies.isEmpty()) {
                    // Extract movie IDs and enrich with database data
                    return similarMovies.stream()
                            .map(movie -> {
                                Integer mid = (Integer) movie.get("movie_id");
                                if (mid == null) {
                                    mid = (Integer) movie.get("movieId");
                                }
                                return mid != null ? mid.longValue() : null;
                            })
                            .filter(Objects::nonNull)
                            .map(mid -> movieRepo.findById(mid)
                                    .map(m -> modelMapper.map(m, MovieDto.class))
                                    .orElse(null))
                            .filter(Objects::nonNull)
                            .collect(Collectors.toList());
                }
            }

        } catch (Exception e) {
            log.error("Error getting similar movies: {}", e.getMessage());
            e.printStackTrace(); // Add this temporarily for debugging
        }

        return Collections.emptyList();
    }
}