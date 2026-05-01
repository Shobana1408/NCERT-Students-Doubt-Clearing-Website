<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="Your answer — NCERT Doubt Solver" />
<c:set var="studentNavActive" value="" />
<c:set var="studentDisplayName" value="${not empty studentDisplayName ? studentDisplayName : sessionScope.studentDisplayName}" />
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/jsp/include/student/head.jspf" %>
</head>
<body class="nc-page d-flex flex-column">
  <%@ include file="/WEB-INF/jsp/include/student/navbar.jspf" %>

  <main class="nc-main flex-grow-1 py-4 py-lg-5">
    <div class="container nc-result-shell px-3 px-md-4">
      <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb small mb-0 nc-breadcrumb py-2 px-3">
          <li class="breadcrumb-item"><a href="${ctx}/student/dashboard" class="text-decoration-none">Dashboard</a></li>
          <li class="breadcrumb-item"><a href="${ctx}/student/ask" class="text-decoration-none">Ask doubt</a></li>
          <li class="breadcrumb-item active" aria-current="page">Result</li>
        </ol>
      </nav>

      <div class="nc-result-hero mb-4">
        <div class="d-flex flex-column flex-lg-row flex-lg-wrap gap-3 justify-content-between align-items-start">
          <div class="pe-lg-3 flex-grow-1">
            <span class="nc-badge-soft"><i class="bi bi-check2-circle me-1"></i> <c:out value="${not empty resultStatusLabel ? resultStatusLabel : 'Solved'}" /></span>
            <h1 class="nc-title-h1 fw-bold mt-3 mb-2">Your personalised answer</h1>
            <p class="nc-result-meta mb-0">
              <c:out value="${not empty doubtSubject ? doubtSubject : '—'}" /> ·
              <c:out value="${not empty doubtChapter ? doubtChapter : '—'}" /> ·
              Response:
              <c:out value="${not empty languageLabel ? languageLabel : doubtLanguage}" />
              <c:if test="${not empty doubtClass}">
                · Class <c:out value="${doubtClass}" />
              </c:if>
            </p>
          </div>
          <div class="d-flex flex-wrap gap-2 flex-shrink-0">
            <a href="${ctx}/student/ask" class="btn btn-nc-outline btn-sm"><i class="bi bi-plus-lg me-1"></i> New doubt</a>
            <a href="#feedbackGroup" class="btn btn-nc-primary btn-sm"><i class="bi bi-hand-thumbs-up me-1"></i> Rate below</a>
          </div>
        </div>
      </div>

      <nav class="nc-jump-nav" aria-label="Section shortcuts">
        <a href="#block-question" class="nc-jump-pill" data-nc-jump="block-question">Question</a>
        <a href="#block-ocr" class="nc-jump-pill" data-nc-jump="block-ocr">OCR</a>
        <a href="#block-answer" class="nc-jump-pill" data-nc-jump="block-answer">Answer</a>
        <a href="#block-steps" class="nc-jump-pill" data-nc-jump="block-steps">Steps</a>
        <a href="#block-simple" class="nc-jump-pill" data-nc-jump="block-simple">Simple</a>
        <a href="#block-translated" class="nc-jump-pill" data-nc-jump="block-translated">Translated</a>
      </nav>

      <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger border-0 shadow-sm mb-4" role="alert"><c:out value="${errorMessage}" /></div>
      </c:if>

      <section id="block-question" class="nc-section-block mb-3">
        <div class="nc-section-header bg-light border-bottom" data-bs-toggle="collapse" data-bs-target="#collapseQuestion" aria-expanded="true" role="button">
          <i class="bi bi-chat-quote text-primary"></i>
          <span>Original question</span>
          <i class="bi bi-chevron-down ms-auto small"></i>
        </div>
        <div id="collapseQuestion" class="collapse show">
          <div class="nc-section-body">
            <p class="mb-0"><c:out value="${not empty questionUsed ? questionUsed : '—'}" /></p>
          </div>
        </div>
      </section>

      <section id="block-ocr" class="nc-section-block mb-3">
        <div class="nc-section-header bg-light border-bottom" data-bs-toggle="collapse" data-bs-target="#collapseOcr" aria-expanded="true" role="button">
          <i class="bi bi-file-earmark-image text-primary"></i>
          <span>OCR extracted text</span>
          <c:if test="${not empty extractedText}">
            <span class="badge bg-secondary bg-opacity-25 text-dark ms-2 small">from image</span>
          </c:if>
          <i class="bi bi-chevron-down ms-auto small"></i>
        </div>
        <div id="collapseOcr" class="collapse show">
          <div class="nc-section-body">
            <c:choose>
              <c:when test="${not empty extractedText}">
                <pre class="mb-0 text-muted small" style="white-space: pre-wrap; font-family: inherit;"><c:out value="${extractedText}" /></pre>
              </c:when>
              <c:otherwise>
                <p class="mb-0 text-muted small">No OCR text (typed question only or no image uploaded).</p>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </section>

      <c:choose>
        <c:when test="${not empty aiResult}">
        <c:if test="${not aiResult.success and not empty aiResult.error}">
          <div class="alert alert-warning border-0 shadow-sm mb-3" role="alert"><c:out value="${aiResult.error}" /></div>
        </c:if>

        <section id="block-answer" class="nc-card p-4 p-md-5 mb-4 border-0" style="background: linear-gradient(145deg, #eff6ff 0%, #ffffff 60%);">
          <div class="d-flex align-items-center gap-2 mb-3">
            <span class="nc-card-icon bg-primary text-white shadow-sm"><i class="bi bi-lightbulb-fill"></i></span>
            <h2 class="h5 fw-bold mb-0">Direct answer</h2>
          </div>
          <p class="lead mb-0" style="line-height: 1.7;">
            <c:out value="${aiResult.answer}" />
          </p>
        </section>

        <section id="block-steps" class="mb-3">
          <div class="nc-section-header bg-white border" data-bs-toggle="collapse" data-bs-target="#collapseSteps" aria-expanded="true" role="button">
            <i class="bi bi-list-ol text-primary"></i>
            <span>Step-by-step explanation</span>
            <i class="bi bi-chevron-down ms-auto small"></i>
          </div>
          <div id="collapseSteps" class="collapse show">
            <div class="nc-section-body bg-white">
              <pre class="mb-0 ps-0 border-0 bg-transparent" style="line-height: 1.85; white-space: pre-wrap; font-family: inherit;"><c:out value="${aiResult.stepByStep}" /></pre>
            </div>
          </div>
        </section>

        <section id="block-simple" class="mb-3">
          <div class="nc-section-header bg-white border" data-bs-toggle="collapse" data-bs-target="#collapseSimple" aria-expanded="true" role="button">
            <i class="bi bi-emoji-smile text-primary"></i>
            <span>Simple explanation</span>
            <i class="bi bi-chevron-down ms-auto small"></i>
          </div>
          <div id="collapseSimple" class="collapse show">
            <div class="nc-section-body bg-white">
              <p class="mb-0"><c:out value="${aiResult.simpleExplanation}" /></p>
            </div>
          </div>
        </section>

        <c:if test="${not empty aiResult.translatedResponse}">
          <section id="block-translated" class="nc-card nc-translated-card p-4 p-md-4 mb-4">
            <div class="d-flex align-items-center flex-wrap gap-2 mb-3">
              <i class="bi bi-translate text-primary fs-4"></i>
              <h2 class="h5 fw-bold mb-0">Translated response</h2>
              <span class="badge rounded-pill bg-primary bg-opacity-10 text-primary border border-primary border-opacity-15 ms-lg-auto"><c:out value="${not empty translationLabel ? translationLabel : languageLabel}" /></span>
            </div>
            <p class="mb-0 nc-translated-body" lang="${not empty translationLang ? translationLang : doubtLanguage}">
              <c:out value="${aiResult.translatedResponse}" />
            </p>
          </section>
        </c:if>
        </c:when>
        <c:otherwise>
          <div class="alert alert-info border-0 shadow-sm mb-4" role="alert">No AI answer payload is available for this request. Check your submission or try again.</div>
        </c:otherwise>
      </c:choose>

      <div id="feedbackGroup" class="nc-feedback-card p-4 p-md-4 mb-4">
        <p class="fw-semibold mb-3 mb-md-4"><i class="bi bi-hand-thumbs-up text-primary me-2"></i>Was this answer helpful?</p>
        <div class="d-flex flex-wrap gap-2">
          <button type="button" class="btn nc-feedback-btn" id="btnHelpfulYes"><i class="bi bi-hand-thumbs-up me-1"></i> Yes, helpful</button>
          <button type="button" class="btn nc-feedback-btn" id="btnHelpfulNo"><i class="bi bi-hand-thumbs-down me-1"></i> Not really</button>
        </div>
      </div>

      <div class="text-center pb-4">
        <a href="${ctx}/student/history" class="btn btn-nc-outline me-2"><i class="bi bi-clock-history me-1"></i> View history</a>
        <a href="${ctx}/student/ask" class="btn btn-nc-primary"><i class="bi bi-plus-lg me-1"></i> Ask another</a>
      </div>
    </div>
  </main>

  <div class="toast-container position-fixed bottom-0 end-0 p-3">
    <div id="feedbackToast" class="toast align-items-center border-0 nc-card shadow" role="alert" aria-live="polite" aria-atomic="true">
      <div class="d-flex">
        <div class="toast-body fw-semibold">Thanks for your feedback!</div>
        <button type="button" class="btn-close me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
      </div>
    </div>
  </div>

  <c:set var="footerNote" value="NCERT Doubt Solver · Result" />
  <%@ include file="/WEB-INF/jsp/include/student/footer.jspf" %>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="${ctx}/js/app.js"></script>
</body>
</html>
