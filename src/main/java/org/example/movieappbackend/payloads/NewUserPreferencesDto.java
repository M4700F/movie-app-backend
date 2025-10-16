package org.example.movieappbackend.payloads;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class NewUserPreferencesDto {
    private Double action = 1.0;
    private Double adventure = 1.0;
    private Double animation = 1.0;
    private Double childrens = 1.0;
    private Double comedy = 1.0;
    private Double crime = 1.0;
    private Double documentary = 1.0;
    private Double drama = 1.0;
    private Double fantasy = 1.0;
    private Double horror = 1.0;
    private Double mystery = 1.0;
    private Double romance = 1.0;
    private Double scifi = 1.0;
    private Double thriller = 1.0;
}
