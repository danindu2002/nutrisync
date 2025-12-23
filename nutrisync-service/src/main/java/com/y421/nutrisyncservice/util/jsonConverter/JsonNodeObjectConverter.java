package com.y421.nutrisyncservice.util.jsonConverter;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class JsonNodeObjectConverter {
    private final ObjectMapper objectMapper = new ObjectMapper();

    public  <T> T mapToClass(JsonNode data, Class<T> valueType) throws IOException {
        return objectMapper.treeToValue(data, valueType);
    }

    public <T> T mapToClass(JsonNode data, JavaType valueType) throws IOException {
        return objectMapper.readValue(objectMapper.treeAsTokens(data), valueType);
    }

    public <T> T mapToClass(JsonNode data, TypeReference<T> valueType) throws IOException {
        return objectMapper.readValue(objectMapper.treeAsTokens(data), valueType);
    }

    public JsonNode mapToJsonNode(Object object) {
        return objectMapper.valueToTree(object);
    }

    public  <T> T mapToObject(Object data, Class<T> valueType) throws IOException {
        return objectMapper.convertValue(data, valueType);
    }

}
