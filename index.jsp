<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>NCERT Doubt Solver</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light py-5">
  <div class="container" style="max-width: 560px;">
    <h1 class="h4 mb-4">NCERT Doubt Solver</h1>
    <ul class="list-unstyled d-grid gap-2">
      <li><a class="btn btn-primary w-100" href="${ctx}/student/login">Student login</a></li>
      <li><a class="btn btn-outline-primary w-100" href="${ctx}/student/dashboard">Student dashboard</a></li>
      <li><a class="btn btn-outline-primary w-100" href="${ctx}/student/ask">Ask a doubt</a></li>
      <li><a class="btn btn-outline-secondary w-100" href="${ctx}/student/doubt/submit">Doubt submit servlet (form)</a></li>
      <li><a class="btn btn-dark w-100" href="${ctx}/admin/login">Admin login</a></li>
      <li><a class="btn btn-outline-dark w-100" href="${ctx}/admin/dashboard">Admin dashboard</a></li>
    </ul>
    <p class="small text-muted mt-4 mb-0">See <code>WEB-INF_JSP_ATTRIBUTES.md</code> for request attributes to set before forwarding.</p>
  </div>
</body>
</html>
