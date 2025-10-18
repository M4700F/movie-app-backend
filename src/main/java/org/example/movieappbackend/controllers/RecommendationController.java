package org.example.movieappbackend.controllers;

import lombok.extern.slf4j.Slf4j;
import org.example.movieappbackend.entities.User;
import org.example.movieappbackend.exceptions.ResourceNotFoundException;
import org.example.movieappbackend.payloads.*;
import org.example.movieappbackend.repositories.UserRepo;
import org.example.movieappbackend.services.RecommendationService;
import org.example.movieappbackend.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/recommendations")
@Slf4j
public class RecommendationController {

    @Autowired
    private RecommendationService recommendationService;

    @Autowired
    private UserService userService;

    @Autowired
    private UserRepo userRepo;

    /**
     * Get personalized recommendations for an authenticated user
     */
    @GetMapping("/me")
    public ResponseEntity<RecommendationResponseDto> getMyRecommendations() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName();
        UserDto userDto = this.userService.getUserByEmail(email);
        log.info("Getting recommendations for authenticated user: {}", userDto.getId());
        RecommendationResponseDto recommendations =
                recommendationService.getRecommendationsForUser(userDto.getId());

        return ResponseEntity.ok(recommendations);
    }

    /**
     * Get recommendations for a specific user (admin only)
     */
    @GetMapping("/user/{userId}")
    public ResponseEntity<RecommendationResponseDto> getUserRecommendations(
            @PathVariable Long userId) {

        RecommendationResponseDto recommendations = recommendationService.getRecommendationsForUser(userId);

        return ResponseEntity.ok(recommendations);
    }

    /**
     * Get recommendations based on genre preferences (for new users)
     */
    @PostMapping("/by-preferences")
    public ResponseEntity<RecommendationResponseDto> getRecommendationsByPreferences(@RequestBody NewUserPreferencesDto preferences) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName();
        UserDto userDto = this.userService.getUserByEmail(email);
        log.info("Getting recommendations by preferences for user: {}", userDto.getId());
        RecommendationResponseDto recommendations =
                recommendationService.getRecommendationsForNewUser(userDto.getId(), preferences);

        return ResponseEntity.ok(recommendations);
    }

    /**
     * Get similar movies
     */
    @GetMapping("/similar/{movieId}")
    public ResponseEntity<List<MovieDto>> getSimilarMovies(
            @PathVariable Long movieId,
            @RequestParam(defaultValue = "10") int limit) {

        log.info("Getting similar movies for movie: {}", movieId);
        List<MovieDto> similarMovies =
                recommendationService.getSimilarMovies(movieId, limit);

        return ResponseEntity.ok(similarMovies);
    }
}
