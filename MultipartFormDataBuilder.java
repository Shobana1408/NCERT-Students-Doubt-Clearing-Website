package com.ncert.doubtsolver.client;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

/**
 * Builds a minimal multipart/form-data body for a single file field (Flask /ocr expects "file" or "image").
 */
public final class MultipartFormDataBuilder {

    private MultipartFormDataBuilder() {
    }

    /**
     * @param fieldName  typically "file" (Flask accepts "file" or "image")
     * @param filename   original filename (for Content-Disposition)
     * @param mimeType   e.g. image/png, image/jpeg
     * @param fileBytes  raw file content
     * @return boundary (without dashes) and full body bytes — use boundary in Content-Type header
     */
    public static MultipartPayload build(String fieldName, String filename, String mimeType, byte[] fileBytes) {
        if (fileBytes == null || fileBytes.length == 0) {
            throw new IllegalArgumentException("fileBytes must not be empty");
        }
        String boundary = "----JavaBoundary" + UUID.randomUUID();
        String delimiter = "--" + boundary + "\r\n";
        String close = "--" + boundary + "--\r\n";

        ByteArrayOutputStream out = new ByteArrayOutputStream(fileBytes.length + 512);
        try {
            out.write(delimiter.getBytes(StandardCharsets.UTF_8));
            String disposition = String.format(
                    "Content-Disposition: form-data; name=\"%s\"; filename=\"%s\"\r\n",
                    escapeQuotes(fieldName),
                    escapeQuotes(filename));
            out.write(disposition.getBytes(StandardCharsets.UTF_8));
            out.write(String.format("Content-Type: %s\r\n\r\n", mimeType).getBytes(StandardCharsets.UTF_8));
            out.write(fileBytes);
            out.write("\r\n".getBytes(StandardCharsets.UTF_8));
            out.write(close.getBytes(StandardCharsets.UTF_8));
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }

        return new MultipartPayload(boundary, out.toByteArray());
    }

    private static String escapeQuotes(String s) {
        return s == null ? "" : s.replace("\"", "\\\"");
    }

    public static final class MultipartPayload {
        private final String boundary;
        private final byte[] body;

        MultipartPayload(String boundary, byte[] body) {
            this.boundary = boundary;
            this.body = body;
        }

        public String boundary() {
            return boundary;
        }

        public byte[] body() {
            return body;
        }
    }
}
