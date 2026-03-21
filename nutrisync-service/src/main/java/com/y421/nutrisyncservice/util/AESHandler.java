package com.y421.nutrisyncservice.util;

import org.apache.commons.codec.binary.Base64;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.Cipher;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.MessageDigest;
import java.util.Arrays;

/**
 * encrypt and decrypt data support class
 */

@Component
public class AESHandler {

    @Value("${aes-secret-key}")
    private String secretKey;


    public String encrypt(String plaintext) {
        try {
            SecretKeySpec secretKeySpec = new SecretKeySpec(secretKey.getBytes(), "AES");

            // Derive IV from the unique identifier
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(getUniqueIdentifier().getBytes());
            byte[] iv = Arrays.copyOf(hash, 12); // Use the first 12 bytes of the hash as IV

            Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
            GCMParameterSpec parameterSpec = new GCMParameterSpec(128, iv); // 128-bit auth tag length
            cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, parameterSpec);

            byte[] encryptedBytes = cipher.doFinal(plaintext.getBytes());
            return Base64.encodeBase64String(encryptedBytes);
        } catch (Exception e) {
            return null;
        }
    }

    public String decrypt(String ciphertext) {
        try {
            byte[] encryptedBytes = Base64.decodeBase64(ciphertext);

            SecretKeySpec secretKeySpec = new SecretKeySpec(secretKey.getBytes(), "AES");

            // Derive IV from the unique identifier
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(getUniqueIdentifier().getBytes());
            byte[] iv = Arrays.copyOf(hash, 12); // Use the first 12 bytes of the hash as IV

            Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
            GCMParameterSpec parameterSpec = new GCMParameterSpec(128, iv); // Same auth tag length and IV
            cipher.init(Cipher.DECRYPT_MODE, secretKeySpec, parameterSpec);

            byte[] decryptedBytes = cipher.doFinal(encryptedBytes);
            return new String(decryptedBytes);
        } catch (Exception e) {
            return null;
        }
    }

    private String getUniqueIdentifier() {
        if (secretKey.length() > 5) {
            return secretKey.substring(secretKey.length() - 5);
        } else {
            return secretKey;
        }
    }

}
