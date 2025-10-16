package org.example.movieappbackend.payloads;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserRatingDto {
    private Integer movieId;
    private Double rating;
}
