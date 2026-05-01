<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ncert.doubtsolver.dto.Doubt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - All Doubts</title>
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
        textarea {
            width: 100%;
            min-height: 90px;
            margin-top: 10px;
            margin-bottom: 10px;
        }
        button {
            padding: 8px 14px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <h2>Admin - All Doubts</h2>

    <%
        List<Doubt> doubts = (List<Doubt>) request.getAttribute("doubts");
        if (doubts == null || doubts.isEmpty()) {
    %>
        <p>No doubts found.</p>
    <%
        } else {
            for (Doubt doubt : doubts) {
    %>
        <div class="card">
            <p><b>Doubt ID:</b> <%= doubt.getId() %></p>
            <p><b>Student:</b> <%= doubt.getStudentName() %></p>
            <p><b>Subject:</b> <%= doubt.getSubjectName() %></p>
            <p><b>Chapter:</b> <%= doubt.getChapterName() %></p>
            <p><b>Question:</b> <%= doubt.getQuestionText() %></p>
            <p><b>Language:</b> <%= doubt.getLanguage() %></p>
            <p><b>Status:</b> <%= doubt.getStatus() %></p>
            <p><b>Created At:</b> <%= doubt.getCreatedAt() %></p>
            <p><b>Current Answer:</b>
                <%= doubt.getAnswerText() == null || doubt.getAnswerText().trim().isEmpty()
                        ? "Not answered yet"
                        : doubt.getAnswerText() %>
            </p>

            <form action="student-view" method="post">
                <input type="hidden" name="doubtId" value="<%= doubt.getId() %>">
                <textarea name="answerText" placeholder="Type answer here"></textarea>
                <button type="submit">Submit Answer</button>
            </form>
        </div>
    <%
            }
        }
    %>
</body>
</html>