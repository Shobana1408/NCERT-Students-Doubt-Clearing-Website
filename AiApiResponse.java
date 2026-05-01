package com.ncert.doubtsolver.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * JSON returned by Flask POST /ai.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class AiApiResponse {

    private boolean success;

    private String answer;

    @JsonProperty("step_by_step")
    private String stepByStep;

    @JsonProperty("simple_explanation")
    private String simpleExplanation;

    @JsonProperty("translated_response")
    private String translatedResponse;

    private String error;

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public String getStepByStep() {
        return stepByStep;
    }

    public void setStepByStep(String stepByStep) {
        this.stepByStep = stepByStep;
    }

    public String getSimpleExplanation() {
        return simpleExplanation;
    }

    public void setSimpleExplanation(String simpleExplanation) {
        this.simpleExplanation = simpleExplanation;
    }

    public String getTranslatedResponse() {
        return translatedResponse;
    }

    public void setTranslatedResponse(String translatedResponse) {
        this.translatedResponse = translatedResponse;
    }

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }
}
