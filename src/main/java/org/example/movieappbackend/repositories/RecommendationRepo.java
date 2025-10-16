package org.example.movieappbackend.repositories;

import org.example.movieappbackend.entities.Recommendation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RecommendationRepo extends JpaRepository<Recommendation, Long> {
    List<Recommendation> findByUserIdOrderByPredictedScoreDesc(Long userId);
    void deleteByUserId(Long userId);
}
