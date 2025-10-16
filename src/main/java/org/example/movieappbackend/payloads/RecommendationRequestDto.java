package org.example.movieappbackend.payloads;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RecommendationRequestDto {
    private Integer userId;
    private List<UserRatingDto> userRatings;
    private NewUserPreferencesDto newUserPreferences;
    private Integer topN = 10;
}
