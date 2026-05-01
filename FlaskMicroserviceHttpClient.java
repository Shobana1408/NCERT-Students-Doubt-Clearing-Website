package com.ncert.doubtsolver.client;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ncert.doubtsolver.dto.AiApiRequest;
import com.ncert.doubtsolver.dto.AiApiResponse;
import com.ncert.doubtsolver.dto.OcrApiResponse;
import com.ncert.doubtsolver.service.FlaskIntegrationException;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;

/**
 * Reusable HTTP client for the Python Flask AI doubt microservice.
 * <p>
 * Endpoints (configurable base URL):
 * <ul>
 *   <li>POST /ocr — multipart/form-data with file field "file"</li>
 *   <li>POST /ai — application/json</li>
 * </ul>
 */
public class FlaskMicroserviceHttpClient {

    private static final int MAX_BODY_LOG_CHARS = 2000;

    private final HttpClient httpClient;
    private final ObjectMapper objectMapper;
    private final String baseUrl;

    /**
     * @param baseUrl e.g. "http://localhost:5000" (no trailing slash)
     */
    public FlaskMicroserviceHttpClient(String baseUrl) {
        this(baseUrl, new ObjectMapper(), defaultHttpClient());
    }

    public FlaskMicroserviceHttpClient(String baseUrl, ObjectMapper objectMapper, HttpClient httpClient) {
        if (baseUrl == null || baseUrl.isBlank()) {
            throw new IllegalArgumentException("baseUrl is required");
        }
        this.baseUrl = baseUrl.endsWith("/") ? baseUrl.substring(0, baseUrl.length() - 1) : baseUrl;
        this.objectMapper = objectMapper;
        this.httpClient = httpClient;
    }

    private static HttpClient defaultHttpClient() {
        return HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(15))
                .build();
    }

    /**
     * POST /ocr: sends image as multipart/form-data and parses JSON {@code extracted_text}.
     *
     * @param fileBytes    image bytes
     * @param filename     original filename (e.g. question.png)
     * @param mimeType     Content-Type for the part (image/png, image/jpeg, …)
     * @return non-null extracted text when Flask returns success
     */
    public String postOcrExtractText(byte[] fileBytes, String filename, String mimeType)
            throws FlaskIntegrationException {
        String safeName = (filename == null || filename.isBlank()) ? "upload.bin" : filename;
        String safeMime = (mimeType == null || mimeType.isBlank()) ? "application/octet-stream" : mimeType;

        MultipartFormDataBuilder.MultipartPayload payload =
                MultipartFormDataBuilder.build("file", safeName, safeMime, fileBytes);

        String url = baseUrl + "/ocr";
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .timeout(Duration.ofMinutes(2))
                .header("Content-Type", "multipart/form-data; boundary=" + payload.boundary())
                .POST(HttpRequest.BodyPublishers.ofByteArray(payload.body()))
                .build();

        return executeJson(request, OcrApiResponse.class).getExtractedText();
    }

    /**
     * POST /ai: sends JSON body and returns structured fields when Flask returns success.
     */
    public AiApiResponse postAiSolve(AiApiRequest body) throws FlaskIntegrationException {
        if (body == null || body.getQuestion() == null || body.getQuestion().isBlank()) {
            throw new IllegalArgumentException("question is required");
        }

        String url = baseUrl + "/ai";
        byte[] json;
        try {
            json = objectMapper.writeValueAsBytes(body);
        } catch (IOException e) {
            throw new FlaskIntegrationException("Failed to serialize AI request", e);
        }

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .timeout(Duration.ofMinutes(3))
                .header("Content-Type", "application/json; charset=UTF-8")
                .POST(HttpRequest.BodyPublishers.ofByteArray(json))
                .build();

        return executeJson(request, AiApiResponse.class);
    }

    /**
     * Executes the request, maps JSON, and maps Flask-level {@code success: false} to an exception.
     */
    private <T> T executeJson(HttpRequest request, Class<T> type) throws FlaskIntegrationException {
        HttpResponse<String> response;
        try {
            response = httpClient.send(request, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FlaskIntegrationException("Flask request interrupted", e);
        } catch (IOException e) {
            throw new FlaskIntegrationException("Flask request failed: " + e.getMessage(), e);
        }

        int status = response.statusCode();
        String raw = response.body() == null ? "" : response.body();

        T parsed;
        try {
            parsed = objectMapper.readValue(raw.isEmpty() ? "{}" : raw, type);
        } catch (IOException e) {
            throw new FlaskIntegrationException(
                    "Invalid JSON from Flask (HTTP " + status + "): " + truncate(raw), e);
        }

        if (parsed instanceof OcrApiResponse) {
            OcrApiResponse ocr = (OcrApiResponse) parsed;
            if (!ocr.isSuccess()) {
                throw new FlaskIntegrationException(
                        ocr.getError() != null ? ocr.getError() : "OCR failed", status);
            }
            if (ocr.getExtractedText() == null) {
                throw new FlaskIntegrationException("OCR success but extracted_text missing", status);
            }
            return parsed;
        }

        if (parsed instanceof AiApiResponse) {
            AiApiResponse ai = (AiApiResponse) parsed;
            if (!ai.isSuccess()) {
                throw new FlaskIntegrationException(
                        ai.getError() != null ? ai.getError() : "AI request failed", status);
            }
            return parsed;
        }

        if (status < 200 || status >= 300) {
            throw new FlaskIntegrationException("Flask returned HTTP " + status + ": " + truncate(raw), status);
        }

        return parsed;
    }

    private static String truncate(String s) {
        if (s.length() <= MAX_BODY_LOG_CHARS) {
            return s;
        }
        return s.substring(0, MAX_BODY_LOG_CHARS) + "...";
    }
}
