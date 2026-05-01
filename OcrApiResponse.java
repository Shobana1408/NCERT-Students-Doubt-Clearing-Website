package com.ncert.doubtsolver.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
public class OcrApiResponse {

    private boolean success;

    @JsonProperty("extracted_text")
    private String extractedText;

    private String error;

    public OcrApiResponse() {
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getExtractedText() {
        return extractedText;
    }

    public void setExtractedText(String extractedText) {
        this.extractedText = extractedText;
    }

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }

    public boolean hasExtractedText() {
        return extractedText != null && !extractedText.trim().isEmpty();
    }

    public boolean hasError() {
        return error != null && !error.trim().isEmpty();
    }

    @Override
    public String toString() {
        return "OcrApiResponse{" +
                "success=" + success +
                ", extractedText='" + extractedText + '\'' +
                ", error='" + error + '\'' +
                '}';
    }
}