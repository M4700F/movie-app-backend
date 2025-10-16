package org.example.movieappbackend.services;

import org.example.movieappbackend.payloads.MovieRecommendationDto;
import org.example.movieappbackend.payloads.NewUserPreferencesDto;
import org.example.movieappbackend.payloads.RecommendationResponseDto;

import java.util.List;

public interface RecommendationService {
    RecommendationResponseDto getRecommendationsForUser(Long userId);
    RecommendationResponseDto getRecommendationsForNewUser(Long userId, NewUserPreferencesDto preferencesDto);
    void saveRecommendationsToCache(Long userId, RecommendationResponseDto mlRecommendations);
    RecommendationResponseDto getCachedRecommendations(Long userId);
    RecommendationResponseDto getPopularMoviesAsRecommendations(Long userId);
    List<MovieRecommendationDto>getSimilarMovies(Long movieId, int topN);
}
