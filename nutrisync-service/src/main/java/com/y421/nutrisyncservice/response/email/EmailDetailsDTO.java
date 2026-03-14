package com.y421.nutrisyncservice.response.email;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class EmailDetailsDTO {
    private String messageBody;
    private String recipient;
    private String subject;
}
