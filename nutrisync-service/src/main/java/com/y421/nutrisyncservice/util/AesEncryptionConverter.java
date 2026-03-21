package com.y421.nutrisyncservice.util;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * encrypt and decrypt data
 */

@Component
@Converter
@Slf4j
public class AesEncryptionConverter implements AttributeConverter<String, String> {

    @Autowired
    private AESHandler aesHandler;

    @Override
    public String convertToDatabaseColumn(String attribute) {
        try {
            return aesHandler.encrypt(attribute);
        } catch (Exception e) {
            // Handle encryption exception
            log.error("Error Occurred", e);
            return null;
        }
    }

    @Override
    public String convertToEntityAttribute(String dbData) {
        try {
            return aesHandler.decrypt(dbData);
        } catch (Exception e) {
            // Handle decryption exception
            log.error("Error Occurred", e);
            return null;
        }
    }
}
