package com.y421.nutrisyncservice.config;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
class CustomResponse {
    private Object data;
    private String message;
    private Integer status;
}