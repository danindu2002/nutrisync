package com.y421.nutrisyncservice.util;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import static com.y421.nutrisyncservice.util.ResponseHandler.generateResponse;

@ControllerAdvice
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(SQLException.class)
    public ResponseEntity<Object> handleSQLException(SQLException ex) {
        return generateResponse("An error occurred while processing the request.", HttpStatus.BAD_REQUEST,null);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Object> handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getFieldErrors().forEach(error ->
                errors.put(error.getField(), error.getDefaultMessage()));
        if (errors.size() > 1){
            return generateResponse("Validation failed", HttpStatus.BAD_REQUEST, null);
        } else {
            String error = errors.values().stream().findFirst().orElse("");
            return generateResponse(error, HttpStatus.BAD_REQUEST, null);
        }
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Object> handleException(Exception ex) {
        return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
    }
}