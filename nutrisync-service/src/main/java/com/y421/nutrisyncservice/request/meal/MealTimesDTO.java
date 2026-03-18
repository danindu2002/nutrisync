package com.y421.nutrisyncservice.request.meal;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MealTimesDTO {

    private String breakfast;
    private String lunch;
    private String dinner;

}
