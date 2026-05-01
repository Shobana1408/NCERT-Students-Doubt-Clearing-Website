package com.ncert.doubtsolver.service;

import com.ncert.doubtsolver.client.FlaskMicroserviceHttpClient;
import com.ncert.doubtsolver.dto.AiApiRequest;
import com.ncert.doubtsolver.dto.AiApiResponse;

import java.io.IOException;
import java.io.InputStream;

/**
 * Higher-level service: OCR (optional) + AI answer. Keeps Servlets thin.
 */
public class FlaskDoubtService {

    private final FlaskMicroserviceHttpClient flaskClient;

    public FlaskDoubtService(FlaskMicroserviceHttpClient flaskClient) {
        this.flaskClient = flaskClient;
    }

    /**
     * Runs OCR on an uploaded image and returns extracted text (for display or as question text).
     */
    public String extractQuestionFromImage(byte[] fileBytes, String filename, String mimeType)
            throws FlaskIntegrationException {
        return flaskClient.postOcrExtractText(fileBytes, filename, mimeType);
    }

    /**
     * Calls Flask /ai with the final question string.
     */
    public AiApiResponse solveDoubt(String question, String subject, String chapter, String language)
            throws FlaskIntegrationException {
        AiApiRequest req = new AiApiRequest(
                question.trim(),
                nullToEmpty(subject),
                nullToEmpty(chapter),
                language == null || language.isBlank() ? "en" : language.trim()
        );
        return flaskClient.postAiSolve(req);
    }

    /**
     * Reads all bytes from an upload {@link InputStream} (e.g. {@code Part#getInputStream()}).
     */
    public static byte[] readAllBytes(InputStream in) throws IOException {
        return in.readAllBytes();
    }

    private static String nullToEmpty(String s) {
        return s == null ? "" : s;
    }
}
