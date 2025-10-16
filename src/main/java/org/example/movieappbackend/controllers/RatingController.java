package org.example.movieappbackend.controllers;

import lombok.extern.slf4j.Slf4j;
import org.example.movieappbackend.entities.Movie;
import org.example.movieappbackend.entities.Rating;
import org.example.movieappbackend.entities.User;
import org.example.movieappbackend.repositories.MovieRepo;
import org.example.movieappbackend.repositories.RatingRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/ratings")
@Slf4j
public class RatingController {

    @Autowired
    private RatingRepo ratingRepo;

    @Autowired
    private MovieRepo movieRepo;

    /**
     * Add or update a rating
     */
    @PostMapping
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Rating> addRating(
            @RequestHeader("X-User-Id") Long userId,
            @RequestParam Long movieId,
            @RequestParam double score) {

        if (score < 0.5 || score > 5.0) {
            return ResponseEntity.badRequest().build();
        }

        Optional<Movie> movieOpt = movieRepo.findById(movieId);
        if (movieOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        User user = new User();
        user.setId(userId);

        Rating rating = new Rating();
        rating.setUser(user);
        rating.setMovie(movieOpt.get());
        rating.setScore(score);

        Rating savedRating = ratingRepo.save(rating);
        log.info("User {} rated movie {} with score {}", userId, movieId, score);

        return ResponseEntity.ok(savedRating);
    }

    /**
     * Get user's ratings
     */
    @GetMapping("/my-ratings")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<List<Rating>> getMyRatings(
            @RequestHeader("X-User-Id") Long userId) {

        List<Rating> ratings = ratingRepo.findByUserId(userId);
        return ResponseEntity.ok(ratings);
    }
}