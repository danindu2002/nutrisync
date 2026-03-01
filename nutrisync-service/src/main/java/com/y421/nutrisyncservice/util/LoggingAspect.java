package com.y421.nutrisyncservice.util;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;

import java.util.Map;

@Aspect
@Component
public class LoggingAspect {

    private static final Logger logger = LogManager.getLogger(LoggingAspect.class);

    private String className = null;
    private String methodName = null;

    @AfterReturning(pointcut = "execution(* com.y421.nutrisyncservice.controller.*.*.*(..))", returning = "responseEntity")
    public void logAfterReturning(JoinPoint joinPoint, ResponseEntity<Object> responseEntity) {
        methodName = joinPoint.getSignature().getName();
        className = joinPoint.getTarget().getClass().getSimpleName();
        String message = extractMessage(responseEntity);
        HttpStatusCode status = responseEntity.getStatusCode();
        String format = className + " -> " + methodName;
        log(getLogLevel((HttpStatus) status), format, message);
    }

    @AfterReturning(pointcut = "execution(* com.y421.nutrisyncservice.service.*.*.*(..))", returning = "responseEntity")
    public void logServiceReturn(JoinPoint joinPoint, ResponseEntity<Object> responseEntity) {
        globalHandler(joinPoint, responseEntity);
    }

    private void globalHandler(JoinPoint joinPoint, ResponseEntity<Object> responseEntity) {
        methodName = joinPoint.getSignature().getName();
        className = joinPoint.getTarget().getClass().getSimpleName();
        HttpStatusCode status = responseEntity.getStatusCode();
        String message;
        if (!status.is2xxSuccessful()) {
            message = extractMessage(responseEntity);
        } else {
            message = "Method executed successfully and gives " + status.value() + " status code";
        }
        String format = className + " -> " + methodName;
        log(getLogLevel((HttpStatus) status), format, message);
    }

    @AfterReturning(pointcut = "execution(* com.y421.nutrisyncservice.util.GlobalExceptionHandler.*(..))", returning = "responseEntity")
    public void logGlobalExceptionHandler(JoinPoint joinPoint, ResponseEntity<Object> responseEntity) {
        Object[] args = joinPoint.getArgs();
        methodName = joinPoint.getSignature().getName();
        className = joinPoint.getTarget().getClass().getSimpleName();
        String message = extractMessage(responseEntity);
        if (args.length > 0 && args[0] instanceof Exception exception) {
            logger.error(() -> className + " -> " + methodName + " | Exception -> " + message, exception);
        }
    }

    @Before("execution(* com.y421.nutrisyncservice.controller.*.*.*(..))")
    public void logBeforeControllerMethod(JoinPoint joinPoint) {
        logBeforeMethod(joinPoint);
    }

    @Before("execution(* com.y421.nutrisyncservice.service.*.*.*(..))")
    public void logBeforeServiceMethods(JoinPoint joinPoint) {
        logBeforeMethod(joinPoint);
    }

    @After("execution(* com.y421.nutrisyncservice.controller.*.*.*(..))")
    public void logAfterControllerMethod(JoinPoint joinPoint) {
        logAfterMethod(joinPoint);
    }

    @After("execution(* com.y421.nutrisyncservice.service.*.*.*(..))")
    public void logAfterServiceMethod(JoinPoint joinPoint) {
        logAfterMethod(joinPoint);
    }

    @AfterThrowing(pointcut = "execution(* com.y421.nutrisyncservice..*(..))", throwing = "exception")
    public void logException(Exception exception) {
        logger.error(() -> className + " -> " + methodName + " | Exception -> ",exception);
    }

    private void logBeforeMethod(JoinPoint joinPoint) {
        methodName = joinPoint.getSignature().getName();
        className = joinPoint.getTarget().getClass().getSimpleName();
        logger.info(() -> className + " -> " + methodName + " | Start");
    }

    private void logAfterMethod(JoinPoint joinPoint) {
        methodName = joinPoint.getSignature().getName();
        className = joinPoint.getTarget().getClass().getSimpleName();
        logger.info(() -> className + " -> " + methodName + " | End");
    }

    private String extractMessage(ResponseEntity<Object> responseEntity) {
        Object responseBody = responseEntity.getBody();

        if (responseBody instanceof Map<?, ?> responseMap) {
            Object messageObj = responseMap.get("message");

            if (messageObj instanceof String str) {
                return str;
            }
        } else if (responseBody instanceof String str) {
            return str;
        }

        return "Unable to extract message from response";
    }

    private LogLevel getLogLevel(HttpStatus status) {
        if (status.is2xxSuccessful()) {
            return LogLevel.INFO;
        } else if (status.is4xxClientError() || status.is5xxServerError()) {
            return LogLevel.WARN;
        } else {
            return LogLevel.DEBUG;
        }
    }

    private void log(LogLevel logLevel, String format, String message) {
        switch (logLevel) {
            case INFO:
                logger.info(() -> format + " | Success -> " + message);
                break;
            case WARN:
                logger.warn(() -> format + " | Error -> " + message);
                break;
            default:
                logger.debug(() -> format + " | Error -> " + message);
        }
    }

    private enum LogLevel {
        INFO, WARN, DEBUG
    }
}

