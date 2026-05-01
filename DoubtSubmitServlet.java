package com.ncert.doubtsolver.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/submit-doubt")
@MultipartConfig
public class DoubtSubmitServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String question = request.getParameter("question");
        String subjectId = request.getParameter("subjectId");
        String chapterId = request.getParameter("chapterId");
        String language = request.getParameter("language");

        request.setAttribute("question", question);
        request.setAttribute("subjectId", subjectId);
        request.setAttribute("chapterId", chapterId);
        request.setAttribute("language", language);
        request.setAttribute("answer", "Your doubt has been submitted successfully.");

        request.getRequestDispatcher("/doubt-result.jsp").forward(request, response);
    }
}