<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="Student Register — NCERT Doubt Solver" />
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
      <a href="${ctx}/student/login" class="btn btn-sm btn-nc-outline">Already have an account?</a>
    </div>
  </nav>

  <main class="nc-auth-wrap py-4 py-lg-0">
    <div class="container">
      <div class="row justify-content-center">
        <div class="col-lg-10 col-xl-9">
          <div class="nc-card p-4 p-md-5">
            <c:if test="${not empty registerError}">
              <div class="alert alert-danger border-0 shadow-sm mb-3" role="alert"><c:out value="${registerError}" /></div>
            </c:if>
            <div class="row g-4 g-lg-5">
              <div class="col-lg-5 nc-card-hero border rounded-4 p-4 d-flex flex-column justify-content-center">
                <div class="nc-card-icon bg-primary bg-opacity-10 text-primary mb-3">
                  <i class="bi bi-person-plus"></i>
                </div>
                <h2 class="fw-bold mb-3">Join thousands of students</h2>
                <p class="text-muted mb-4">Get instant, syllabus-aligned help — type your doubt or snap a photo of the question.</p>
                <ul class="list-unstyled small text-muted mb-0">
                  <li class="mb-2"><i class="bi bi-check-circle-fill text-success me-2"></i> Answers in simple language</li>
                  <li class="mb-2"><i class="bi bi-check-circle-fill text-success me-2"></i> Step-by-step breakdowns</li>
                  <li><i class="bi bi-check-circle-fill text-success me-2"></i> Multilingual support</li>
                </ul>
              </div>
              <div class="col-lg-7">
                <h2 class="fw-bold mb-1">Create your account</h2>
                <p class="text-muted mb-4">Takes less than a minute.</p>
                <form action="${not empty registerFormAction ? registerFormAction : '#'}" method="post" class="row g-3">
                  <div class="col-md-6">
                    <label class="form-label" for="fullName">Full name</label>
                    <input type="text" class="form-control" id="fullName" name="fullName" placeholder="Your name" value="<c:out value='${param.fullName}' />" required />
                  </div>
                  <div class="col-md-6">
                    <label class="form-label" for="regEmail">Email</label>
                    <input type="email" class="form-control" id="regEmail" name="email" placeholder="you@school.edu" value="<c:out value='${param.email}' />" required />
                  </div>
                  <div class="col-12">
                    <label class="form-label" for="school">School / Class (optional)</label>
                    <input type="text" class="form-control" id="school" name="schoolClass" placeholder="e.g. Class 10" value="<c:out value='${param.schoolClass}' />" />
                  </div>
                  <div class="col-md-6">
                    <label class="form-label" for="regPass">Password</label>
                    <input type="password" class="form-control" id="regPass" name="password" placeholder="Min. 8 characters" minlength="8" required autocomplete="new-password" />
                  </div>
                  <div class="col-md-6">
                    <label class="form-label" for="regPass2">Confirm password</label>
                    <input type="password" class="form-control" id="regPass2" name="password2" placeholder="Repeat password" required autocomplete="new-password" />
                  </div>
                  <div class="col-12">
                    <div class="form-check">
                      <input class="form-check-input" type="checkbox" id="terms" name="terms" value="1" required />
                      <label class="form-check-label small text-muted" for="terms">I agree to the terms and privacy policy.</label>
                    </div>
                  </div>
                  <div class="col-12 pt-2">
                    <button type="submit" class="btn btn-nc-primary px-5">Register</button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </main>

  <footer class="nc-footer py-4 mt-auto">
    <div class="container-fluid px-3 px-lg-4 text-center">
      <span class="text-muted small">NCERT Doubt Solver · Demo UI</span>
    </div>
  </footer>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="${ctx}/js/app.js"></script>
</body>
</html>
