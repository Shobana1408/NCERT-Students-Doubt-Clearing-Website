<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Admin sign in — NCERT Doubt Solver</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet" />
  <link href="${ctx}/css/admin-theme.css" rel="stylesheet" />
</head>
<body>
  <div class="adm-auth-page">
    <div class="adm-auth-card adm-form">
      <div class="adm-auth-logo">
        <i class="bi bi-shield-lock"></i>
      </div>
      <h1 class="h4 fw-bold mb-1">Administrator</h1>
      <p class="text-muted small mb-4">Sign in to manage doubts, content, and analytics.</p>
      <c:if test="${not empty adminLoginError}">
        <div class="alert alert-danger border-0 shadow-sm mb-3" role="alert"><c:out value="${adminLoginError}" /></div>
      </c:if>
      <form action="${not empty adminLoginFormAction ? adminLoginFormAction : '#'}" method="post">
        <div class="mb-3">
          <label class="form-label small fw-semibold" for="adminEmail">Work email</label>
          <input type="email" class="form-control" id="adminEmail" name="email" placeholder="admin@institution.edu" value="<c:out value='${param.email}' />" required autocomplete="username" />
        </div>
        <div class="mb-3">
          <label class="form-label small fw-semibold" for="adminPass">Password</label>
          <input type="password" class="form-control" id="adminPass" name="password" placeholder="••••••••" required autocomplete="current-password" />
        </div>
        <div class="d-flex justify-content-between align-items-center mb-4">
          <div class="form-check">
            <input class="form-check-input" type="checkbox" id="remember" name="remember" value="1" />
            <label class="form-check-label small" for="remember">Stay signed in</label>
          </div>
          <a href="#" class="small text-decoration-none fw-semibold">Forgot password?</a>
        </div>
        <button type="submit" class="btn btn-adm-primary w-100 py-2">Sign in to console</button>
      </form>
      <p class="text-center text-muted small mt-4 mb-0">
        <i class="bi bi-mortarboard me-1"></i> Student portal:
        <a href="${ctx}/student/login" class="text-decoration-none">Open student login</a>
      </p>
    </div>
  </div>
</body>
</html>
