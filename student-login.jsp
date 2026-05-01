<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="Student Login — NCERT Doubt Solver" />
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/jsp/include/student/head.jspf" %>
</head>
<body class="nc-page">
  <nav class="navbar nc-navbar py-2">
    <div class="container-fluid px-3 px-lg-4">
      <a class="navbar-brand nc-brand d-flex align-items-center gap-2" href="${ctx}/student/login">
        <span class="nc-brand-mark">
          <i class="bi bi-mortarboard-fill fs-5"></i>
        </span>
        <span>NCERT Doubt<span class="text-primary">Solver</span></span>
      </a>
      <a href="${ctx}/student/register" class="btn btn-sm btn-nc-outline">Create account</a>
    </div>
  </nav>

  <main class="nc-auth-wrap d-flex flex-column flex-lg-row">
    <div class="col-lg-6 d-none d-lg-flex nc-auth-visual align-items-center justify-content-center p-5">
      <div class="position-relative z-1 text-center text-lg-start px-lg-5">
        <p class="text-white-50 text-uppercase small fw-semibold mb-3 tracking-wide">AI study companion</p>
        <h1 class="display-5 fw-bold mb-4">Clear doubts in <span class="text-warning">your language</span></h1>
        <p class="lead opacity-90 mb-4">Step-by-step NCERT explanations, anytime — built for real exam prep.</p>
        <div class="d-flex flex-wrap gap-3 justify-content-center justify-content-lg-start">
          <span class="badge bg-white bg-opacity-10 px-3 py-2 rounded-pill"><i class="bi bi-check2-circle me-1"></i> Multilingual</span>
          <span class="badge bg-white bg-opacity-10 px-3 py-2 rounded-pill"><i class="bi bi-image me-1"></i> OCR from photos</span>
          <span class="badge bg-white bg-opacity-10 px-3 py-2 rounded-pill"><i class="bi bi-patch-check me-1"></i> NCERT-focused</span>
        </div>
      </div>
    </div>
    <div class="col-lg-6 d-flex align-items-center justify-content-center p-4 p-lg-5">
      <div class="nc-card nc-auth-form-card w-100 p-4 p-md-5">
        <c:if test="${not empty loginError}">
          <div class="alert alert-danger border-0 shadow-sm mb-3" role="alert"><c:out value="${loginError}" /></div>
        </c:if>
        <div class="mb-4">
          <h2 class="fw-bold mb-2">Welcome back</h2>
          <p class="text-muted mb-0">Sign in to continue learning.</p>
        </div>
        <form action="${not empty loginFormAction ? loginFormAction : '#'}" method="post">
          <div class="mb-3">
            <label class="form-label" for="email">Email</label>
            <div class="input-group">
              <span class="input-group-text bg-light border-end-0 rounded-start-3 text-muted"><i class="bi bi-envelope"></i></span>
              <input type="email" class="form-control border-start-0 rounded-end-3" id="email" name="email" placeholder="you@school.edu" value="<c:out value='${param.email}' />" required autocomplete="username" />
            </div>
          </div>
          <div class="mb-2">
            <label class="form-label" for="password">Password</label>
            <div class="input-group">
              <span class="input-group-text bg-light border-end-0 rounded-start-3 text-muted"><i class="bi bi-lock"></i></span>
              <input type="password" class="form-control border-start-0 rounded-end-3" id="password" name="password" placeholder="••••••••" required autocomplete="current-password" />
            </div>
          </div>
          <div class="d-flex justify-content-between align-items-center mb-4">
            <div class="form-check">
              <input class="form-check-input" type="checkbox" id="remember" name="remember" value="1" />
              <label class="form-check-label small text-muted" for="remember">Remember me</label>
            </div>
            <a href="#" class="small text-decoration-none fw-semibold">Forgot password?</a>
          </div>
          <button type="submit" class="btn btn-nc-primary w-100 py-2 mb-3">Sign in</button>
          <p class="text-center text-muted small mb-0">
            New here? <a href="${ctx}/student/register" class="fw-semibold text-decoration-none">Create a student account</a>
          </p>
        </form>
      </div>
    </div>
  </main>

  <footer class="nc-footer py-4 mt-auto">
    <div class="container-fluid px-3 px-lg-4 text-center text-md-start">
      <span class="fw-semibold text-dark">NCERT Doubt Solver</span>
      <span class="text-muted ms-2">© 2025 · Demo UI</span>
    </div>
  </footer>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="${ctx}/js/app.js"></script>
</body>
</html>
