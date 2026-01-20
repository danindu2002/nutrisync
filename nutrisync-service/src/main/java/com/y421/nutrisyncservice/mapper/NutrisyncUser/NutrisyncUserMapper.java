package com.y421.nutrisyncservice.mapper.NutrisyncUser;

import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import com.y421.nutrisyncservice.request.nutrisyncUser.NutrisyncUserRequestDto;
import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public interface NutrisyncUserMapper {

    NutrisyncUser toEntity(NutrisyncUserRequestDto userRequestDto);
}
