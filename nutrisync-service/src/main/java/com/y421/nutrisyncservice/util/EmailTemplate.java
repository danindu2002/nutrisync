package com.y421.nutrisyncservice.util;

import org.springframework.stereotype.Component;

@Component
public class EmailTemplate {

    // Brand Colors
    private static final String BRAND_RED = "#EF4444";
    private static final String BRAND_DARK = "#393C43";
    private static final String BRAND_GRAY_BG = "#F9FAFB";

    // Account Creation Email (Standard)
    public String emailTemplateAccountCreate(String username, String password, String link) {
        String title = "Welcome to NutriSync!";
        String content =
                "<p style=\"color: " + BRAND_DARK + "; font-size: 16px; line-height: 24px; margin-bottom: 20px;\">" +
                        "Hello," +
                        "</p>" +
                        "<p style=\"color: " + BRAND_DARK + "; font-size: 16px; line-height: 24px; margin-bottom: 20px;\">" +
                        "Your user account has been successfully created. We are excited to have you on board! Below are your temporary credentials:" +
                        "</p>" +
                        // Credentials Box
                        "<div style=\"background-color: #F3F4F6; border-left: 4px solid " + BRAND_RED + "; padding: 15px; margin-bottom: 25px; border-radius: 4px;\">" +
                        "<p style=\"margin: 5px 0; color: " + BRAND_DARK + "; font-size: 14px;\"><strong>Username:</strong> " + username + "</p>" +
                        "<p style=\"margin: 5px 0; color: " + BRAND_DARK + "; font-size: 14px;\"><strong>Temporary Password:</strong> " + password + "</p>" +
                        "</div>" +
                        "<p style=\"color: " + BRAND_DARK + "; font-size: 16px; line-height: 24px; margin-bottom: 30px;\">" +
                        "Please log in and change your password immediately." +
                        "</p>" +
                        // Button
                        "<table role=\"presentation\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">" +
                        "<tr>" +
                        "<td align=\"center\">" +
                        "<a href=\"" + link + "\" style=\"background-color: " + BRAND_RED + "; color: #ffffff; text-decoration: none; font-weight: bold; font-size: 16px; padding: 12px 30px; border-radius: 50px; display: inline-block; mso-padding-alt:0;\">" +
                        "Login to Dashboard" +
                        "</a>" +
                        "</td>" +
                        "</tr>" +
                        "</table>";

        return getHtmlWrapper(title, content);
    }

    // Account Creation Email (Google)
    public String emailTemplateAccountCreateGoogle(String email, String loginURL) {
        String title = "Account Connected";
        String content =
                "<p style=\"color: " + BRAND_DARK + "; font-size: 16px; line-height: 24px; margin-bottom: 20px;\">" +
                        "Hello," +
                        "</p>" +
                        "<p style=\"color: " + BRAND_DARK + "; font-size: 16px; line-height: 24px; margin-bottom: 20px;\">" +
                        "Your NutriSync account has been successfully linked with your Gmail." +
                        "</p>" +
                        // Email Box
                        "<div style=\"background-color: #F3F4F6; border-radius: 6px; padding: 15px; text-align: center; margin-bottom: 25px;\">" +
                        "<span style=\"color: #6B7280; font-size: 12px; text-transform: uppercase; letter-spacing: 1px;\">Registered Email</span><br>" +
                        "<strong style=\"color: " + BRAND_DARK + "; font-size: 18px;\">" + email + "</strong>" +
                        "</div>" +
                        "<p style=\"color: " + BRAND_DARK + "; font-size: 16px; line-height: 24px; margin-bottom: 30px;\">" +
                        "You can now access all features using your google credentials." +
                        "</p>" +
                        // Button
                        "<table role=\"presentation\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">" +
                        "<tr>" +
                        "<td align=\"center\">" +
                        "<a href=\"" + loginURL + "\" style=\"background-color: " + BRAND_RED + "; color: #ffffff; text-decoration: none; font-weight: bold; font-size: 16px; padding: 12px 30px; border-radius: 50px; display: inline-block; mso-padding-alt:0;\">" +
                        "Login Now" +
                        "</a>" +
                        "</td>" +
                        "</tr>" +
                        "</table>";

        return getHtmlWrapper(title, content);
    }

    // Forgot Password Email
    public String emailTemplateForgotPassword(String otp) {
        String title = "Reset Your Password";
        String content =
                "<p style=\"color: " + BRAND_DARK + "; font-size: 16px; line-height: 24px; margin-bottom: 20px;\">" +
                        "Hello," +
                        "</p>" +
                        "<p style=\"color: " + BRAND_DARK + "; font-size: 16px; line-height: 24px; margin-bottom: 20px;\">" +
                        "We received a request to reset the password for your NutriSync account. If you did not make this request, please ignore this email." +
                        "</p>" +
                        "<p style=\"color: " + BRAND_DARK + "; font-size: 16px; line-height: 24px; margin-bottom: 30px;\">" +
                        "To reset your password, enter this One Time Passcode(OTP). This OTP will expire in 15 minutes." +
                        "</p>" +
                        // OTP below
                        "<p style=\"color: " + BRAND_DARK + "; font-size: 16px; line-height: 24px; margin-bottom: 20px;\">" + otp + "</p>";

        return getHtmlWrapper(title, content);
    }

    // design
    private String getHtmlWrapper(String title, String bodyContent) {
        return "<!doctype html>\n" +
                "<html lang=\"en-US\">\n" +
                "<head>\n" +
                "    <meta content=\"text/html; charset=utf-8\" http-equiv=\"Content-Type\" />\n" +
                "    <title>" + title + "</title>\n" +
                "    <style type=\"text/css\">\n" +
                "        a:hover { opacity: 0.9; }\n" +
                "        body { margin: 0; padding: 0; background-color: " + BRAND_GRAY_BG + "; }\n" +
                "    </style>\n" +
                "</head>\n" +
                "<body marginheight=\"0\" topmargin=\"0\" marginwidth=\"0\" style=\"margin: 0px; background-color: " + BRAND_GRAY_BG + "; font-family: 'Open Sans', Helvetica, Arial, sans-serif;\" leftmargin=\"0\">\n" +
                "    <table cellspacing=\"0\" border=\"0\" cellpadding=\"0\" width=\"100%\" bgcolor=\"" + BRAND_GRAY_BG + "\">\n" +
                "        <tr>\n" +
                "            <td>\n" +
                "                <table style=\"max-width: 600px; margin: 0 auto;\" width=\"100%\" border=\"0\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\">\n" +
                "                    \n" +
                "                    <tr><td style=\"height: 40px;\">&nbsp;</td></tr>\n" +
                "                    \n" +
                "                    \n" +
                "                    <tr>\n" +
                "                        <td style=\"text-align: center; padding-bottom: 20px;\">\n" +
                "                            <h2 style=\"color: " + BRAND_RED + "; margin: 0; font-size: 24px; font-weight: 700; letter-spacing: -0.5px;\">NutriSync</h2>\n" +
                "                        </td>\n" +
                "                    </tr>\n" +
                "\n" +
                "                    \n" +
                "                    <tr>\n" +
                "                        <td>\n" +
                "                            <table width=\"100%\" border=\"0\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\"\n" +
                "                                style=\"background: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.04); border-top: 4px solid " + BRAND_RED + ";\">\n" +
                "                                <tr>\n" +
                "                                    <td style=\"padding: 40px 30px;\">\n" +
                "                                        \n" +
                "                                        <h1 style=\"color: " + BRAND_DARK + "; font-weight: 700; margin: 0 0 20px 0; font-size: 24px; text-align: center;\">" + title + "</h1>\n" +
                "                                        \n" +
                "                                        <div style=\"width: 40px; height: 2px; background-color: #E5E7EB; margin: 0 auto 30px auto;\"></div>\n" +
                "                                        \n" +
                "                                        " + bodyContent + "\n" +
                "                                        \n" +
                "                                    </td>\n" +
                "                                </tr>\n" +
                "                            </table>\n" +
                "                        </td>\n" +
                "                    </tr>\n" +
                "\n" +
                "                    \n" +
                "                    <tr>\n" +
                "                        <td style=\"padding: 20px; text-align: center;\">\n" +
                "                            <p style=\"color: #9CA3AF; font-size: 12px; margin: 0;\">&copy; 2024 NutriSync. All rights reserved.</p>\n" +
                "                            <p style=\"color: #9CA3AF; font-size: 12px; margin: 5px 0 0 0;\">Designed for a healthier you.</p>\n" +
                "                        </td>\n" +
                "                    </tr>\n" +
                "                    <tr><td style=\"height: 40px;\">&nbsp;</td></tr>\n" +
                "                </table>\n" +
                "            </td>\n" +
                "        </tr>\n" +
                "    </table>\n" +
                "</body>\n" +
                "</html>";
    }
}