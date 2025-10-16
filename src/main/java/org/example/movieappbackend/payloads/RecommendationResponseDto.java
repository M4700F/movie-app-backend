package org.example.movieappbackend.payloads;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RecommendationResponseDto {
    private Integer userId;
    private List<MovieRecommendationDto> recommendations;
}
