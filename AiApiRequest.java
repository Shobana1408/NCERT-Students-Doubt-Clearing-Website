package com.ncert.doubtsolver.dto;

/**
 * JSON body for Flask POST /ai.
 */
public class AiApiRequest {

    private String question;
    private String subject;
    private String chapter;
    private String language;

    public AiApiRequest() {
    }

    public AiApiRequest(String question, String subject, String chapter, String language) {
        this.question = question;
        this.subject = subject;
        this.chapter = chapter;
        this.language = language;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getChapter() {
        return chapter;
    }

    public void setChapter(String chapter) {
        this.chapter = chapter;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }
}
