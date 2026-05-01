<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ncert.doubtsolver.dto.Doubt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Doubt History</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 30px;
        }
        .card {
            border: 1px solid #cccccc;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 8px;
        }
        .title {
            font-weight: bold;
            margin-bottom: 8px;
        }
        .empty {
            color: #666666;
        }
    </style>
</head>
<body>
    <h2>My Doubt History</h2>

    <%
        List<Doubt> doubts = (List<Doubt>) request.getAttribute("doubts");
        if (doubts == null || doubts.isEmpty()) {
    %>
        <p class="empty">No doubts found.</p>
    <%
        } else {
            for (Doubt doubt : doubts) {
    %>
        <div class="card">
            <div class="title">Question</div>
            <p><%= doubt.getQuestionText() %></p>

            <p><b>Subject:</b> <%= doubt.getSubjectName() %></p>
            <p><b>Chapter:</b> <%= doubt.getChapterName() %></p>
            <p><b>Language:</b> <%= doubt.getLanguage() %></p>
            <p><b>Status:</b> <%= doubt.getStatus() %></p>
            <p><b>Created At:</b> <%= doubt.getCreatedAt() %></p>

            <p><b>Answer:</b>
                <%= doubt.getAnswerText() == null || doubt.getAnswerText().trim().isEmpty()
                        ? "Not answered yet"
                        : doubt.getAnswerText() %>
            </p>
        </div>
    <%
            }
        }
    %>
</body>
</html>