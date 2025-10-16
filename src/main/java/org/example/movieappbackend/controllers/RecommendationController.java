package org.example.movieappbackend.controllers;

import lombok.extern.slf4j.Slf4j;
import org.example.movieappbackend.payloads.MovieRecommendationDto;
import org.example.movieappbackend.payloads.NewUserPreferencesDto;
import org.example.movieappbackend.payloads.RecommendationResponseDto;
import org.example.movieappbackend.services.RecommendationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/recommendations")
@Slf4j
public class RecommendationController {

    @Autowired
    private RecommendationService recommendationService;

    /**
     * Get personalized recommendations for authenticated user
     */
    @GetMapping("/me")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<RecommendationResponseDto> getMyRecommendations(
            @RequestHeader("X-User-Id") Long userId) {

        log.info("Getting recommendations for authenticated user: {}", userId);
        RecommendationResponseDto recommendations =
                recommendationService.getRecommendationsForUser(userId);

        return ResponseEntity.ok(recommendations);
    }

    /**
     * Get recommendations for a specific user (admin only)
     */
    @GetMapping("/user/{userId}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<RecommendationResponseDto> getUserRecommendations(
            @PathVariable Long userId) {

        RecommendationResponseDto recommendations =
                recommendationService.getRecommendationsForUser(userId);

        return ResponseEntity.ok(recommendations);
    }

    /**
     * Get recommendations based on genre preferences (for new users)
     */
    @PostMapping("/by-preferences")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<RecommendationResponseDto> getRecommendationsByPreferences(
            @RequestHeader("X-User-Id") Long userId,
            @RequestBody NewUserPreferencesDto preferences) {

        log.info("Getting recommendations by preferences for user: {}", userId);
        RecommendationResponseDto recommendations =
                recommendationService.getRecommendationsForNewUser(userId, preferences);

        return ResponseEntity.ok(recommendations);
    }

    /**
     * Get similar movies
     */
    @GetMapping("/similar/{movieId}")
    public ResponseEntity<List<MovieRecommendationDto>> getSimilarMovies(
            @PathVariable Long movieId,
            @RequestParam(defaultValue = "10") int limit) {

        log.info("Getting similar movies for movie: {}", movieId);
        List<MovieRecommendationDto> similarMovies =
                recommendationService.getSimilarMovies(movieId, limit);

        return ResponseEntity.ok(similarMovies);
    }
}
