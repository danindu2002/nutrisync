package com.y421.nutrisyncservice.util;

import com.y421.nutrisyncservice.response.email.EmailDetailsDTO;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class EmailService {

    @Value("${spring.mail.username}")
    private String emailSender;

    private final JavaMailSender javaMailSender;

    @Async
    public void sendEmail(EmailDetailsDTO emailDetailsDTO) {
        try {
            MimeMessage mimeMessage = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, "utf-8");
            helper.setFrom(emailSender);
            helper.setTo(emailDetailsDTO.getRecipient());
            helper.setSubject(emailDetailsDTO.getSubject());
            helper.setText(emailDetailsDTO.getMessageBody(), true);
            javaMailSender.send(mimeMessage);
        } catch (MessagingException e) {
            throw new IllegalArgumentException(e);
        }
    }
}
