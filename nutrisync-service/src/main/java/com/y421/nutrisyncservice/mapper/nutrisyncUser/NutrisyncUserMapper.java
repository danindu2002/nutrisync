package com.y421.nutrisyncservice.mapper.nutrisyncUser;

import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import com.y421.nutrisyncservice.request.nutrisyncUser.NutrisyncUserRequestDto;
import com.y421.nutrisyncservice.response.nutrisyncUser.UserDetailsDTO;
import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public interface NutrisyncUserMapper {
    NutrisyncUser toEntity(NutrisyncUserRequestDto userRequestDto);
    UserDetailsDTO toUserDetailsDTO(NutrisyncUser nutrisyncUser);
}
