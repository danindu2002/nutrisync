package com.y421.nutrisyncservice.mapper.meal;

import com.y421.nutrisyncservice.entity.foodMaster.FoodMaster;
import com.y421.nutrisyncservice.response.meal.FoodIdentificationDTO;
import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public interface MealMapper {
    FoodIdentificationDTO toFoodIdentificationDTO(FoodMaster foodMaster);
}
