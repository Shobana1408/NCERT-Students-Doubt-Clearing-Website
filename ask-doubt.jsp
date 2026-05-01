<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="Ask a doubt — NCERT Doubt Solver" />
<c:set var="extraCss" value="ask-doubt.css" />
<c:set var="studentNavActive" value="ask" />
<c:set var="studentDisplayName" value="${not empty studentDisplayName ? studentDisplayName : sessionScope.studentDisplayName}" />
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/jsp/include/student/head.jspf" %>
</head>
<body class="nc-page d-flex flex-column">
  <%@ include file="/WEB-INF/jsp/include/student/navbar.jspf" %>

  <main class="nc-main flex-grow-1 py-4 py-lg-5">
    <div class="container px-3 px-md-4" style="max-width: 920px;">
      <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb small mb-0 nc-breadcrumb py-2 px-3">
          <li class="breadcrumb-item"><a href="${ctx}/student/dashboard" class="text-decoration-none">Dashboard</a></li>
          <li class="breadcrumb-item active" aria-current="page">Ask doubt</li>
        </ol>
      </nav>

      <div class="text-center ad-hero mb-4 mb-lg-5">
        <span class="nc-badge-soft"><i class="bi bi-stars me-1"></i> Step 1 of 2</span>
        <h1 class="fw-bold mt-3 mb-2">Ask your NCERT doubt</h1>
        <p class="text-muted mb-0">Tell us where you’re studying, then type your question or upload a photo — we’ll answer in the language you choose.</p>
      </div>

      <div id="formError" class="alert alert-danger ad-alert-inline border-0 shadow-sm d-none mb-4" role="alert">
        <div class="d-flex gap-2 align-items-start">
          <i class="bi bi-exclamation-circle-fill flex-shrink-0 mt-1"></i>
          <span id="formErrorText"></span>
        </div>
      </div>

      <c:if test="${not empty formError}">
        <div class="alert alert-danger border-0 shadow-sm mb-4" role="alert"><c:out value="${formError}" /></div>
      </c:if>

      <form id="doubtForm" class="ad-form-card p-4 p-md-5" action="${ctx}/student/doubt/submit" method="post" enctype="multipart/form-data" novalidate>
        <div class="row g-4">
          <div class="col-12">
            <div class="ad-tip-box text-start mb-1">
              <strong><i class="bi bi-lightbulb text-warning me-1"></i>How it works</strong>
              — Pick your <strong>class</strong> and <strong>topic</strong> so answers stay NCERT-relevant. Use <strong>text</strong> or a <strong>screenshot</strong> (or both). Good lighting helps OCR read your page correctly.
            </div>
          </div>

          <div class="col-md-6 col-lg-3">
            <label class="ad-label d-block" for="classGrade"><i class="bi bi-building text-primary me-1"></i> Class</label>
            <select class="form-select" id="classGrade" name="class" required>
              <option value="" disabled="disabled" <c:if test="${empty param.class}">selected="selected"</c:if>>Select class</option>
              <c:forEach var="g" begin="6" end="12">
                <option value="${g}" <c:if test="${param.class == g}">selected="selected"</c:if>>Class ${g}</option>
              </c:forEach>
            </select>
            <p class="ad-hint mb-0">Matches NCERT stage.</p>
          </div>

          <div class="col-md-6 col-lg-3">
            <label class="ad-label d-block" for="subject"><i class="bi bi-book-half text-primary me-1"></i> Subject</label>
            <select class="form-select" id="subject" name="subject" required>
              <option value="" disabled="disabled" <c:if test="${empty param.subject}">selected="selected"</c:if>>Select subject</option>
              <c:choose>
                <c:when test="${not empty subjectList}">
                  <c:forEach var="s" items="${subjectList}">
                    <option value="<c:out value='${s.name}' />" ${param.subject == s.name ? 'selected' : ''}><c:out value="${s.name}" /></option>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <option value="Mathematics">Mathematics</option>
                  <option value="Science">Science</option>
                  <option value="Social Science">Social Science</option>
                  <option value="English">English</option>
                  <option value="Hindi">Hindi</option>
                </c:otherwise>
              </c:choose>
            </select>
            <p class="ad-hint mb-0">Chapters update automatically.</p>
          </div>

          <div class="col-md-6 col-lg-3">
            <label class="ad-label d-block" for="chapter"><i class="bi bi-bookmark text-primary me-1"></i> Chapter</label>
            <select class="form-select" id="chapter" name="chapter" required disabled>
              <option value="">Choose a subject first</option>
            </select>
            <p class="ad-hint mb-0">Rough topic area is fine.</p>
          </div>

          <div class="col-md-6 col-lg-3">
            <label class="ad-label d-block" for="language"><i class="bi bi-translate text-primary me-1"></i> Answer language</label>
            <select class="form-select" id="language" name="language" required>
              <option value="en" ${empty param.language or param.language == 'en' ? 'selected' : ''}>English</option>
              <option value="hi" ${param.language == 'hi' ? 'selected' : ''}>Hindi (हिंदी)</option>
              <option value="ta" ${param.language == 'ta' ? 'selected' : ''}>Tamil</option>
              <option value="te" ${param.language == 'te' ? 'selected' : ''}>Telugu</option>
              <option value="bn" ${param.language == 'bn' ? 'selected' : ''}>Bengali</option>
              <option value="mr" ${param.language == 'mr' ? 'selected' : ''}>Marathi</option>
            </select>
            <p class="ad-hint mb-0">Full response + simple terms.</p>
          </div>

          <div class="col-12">
            <label class="ad-label d-block" for="questionText"><i class="bi bi-pencil text-primary me-1"></i> Your question</label>
            <textarea class="form-control" id="questionText" name="question" rows="6" placeholder="Example: Explain the laws of reflection with a ray diagram. Or leave blank if you’re only uploading an image."><c:out value="${param.question}" /></textarea>
            <p class="ad-hint mb-0"><i class="bi bi-info-circle me-1"></i>Either type here <strong>or</strong> add an image below — at least one is required.</p>
          </div>

          <div class="col-12">
            <label class="ad-label d-block"><i class="bi bi-image text-primary me-1"></i> Question image <span class="text-muted fw-normal">(optional)</span></label>
            <input type="file" class="d-none" id="questionImage" name="image" accept="image/png,image/jpeg,image/webp" />
            <div id="dropzone" class="ad-dropzone" role="button" tabindex="0" aria-label="Upload question image">
              <div id="dropzonePlaceholder">
                <i class="bi bi-cloud-arrow-up display-6 text-primary d-block mb-2"></i>
                <p class="fw-semibold mb-1">Drag &amp; drop your image here</p>
                <p class="small text-muted mb-0">or click to browse · PNG, JPG, WebP · max ~16 MB</p>
              </div>
              <div class="ad-preview-wrap position-relative d-none w-100" id="previewContainer">
                <button type="button" class="btn btn-sm btn-danger rounded-pill ad-btn-clear d-none" id="btnClearImage" title="Remove image" aria-label="Remove image">
                  <i class="bi bi-x-lg"></i> Remove
                </button>
                <img id="imagePreview" src="" alt="Question preview" class="ad-preview-img d-none mx-auto d-block" />
              </div>
            </div>
          </div>

          <div class="col-12 d-flex flex-wrap gap-2 justify-content-between align-items-center pt-2 border-top mt-1">
            <p class="small text-muted mb-0">
              <i class="bi bi-shield-check text-success me-1"></i> Submits to the servlet for OCR + AI (Flask) processing.
            </p>
            <button type="submit" class="btn btn-nc-primary btn-lg px-4" id="btnSubmitDoubt">
              <span class="submit-label"><i class="bi bi-send-fill me-2"></i> Get answer</span>
            </button>
          </div>
        </div>
      </form>
    </div>
  </main>

  <div id="loadingOverlay" class="ad-loading-overlay" aria-hidden="true" aria-live="polite">
    <div class="ad-loading-card">
      <div class="ad-spinner" role="status" aria-label="Loading"></div>
      <p class="ad-loading-title mb-1">Working on your answer</p>
      <p class="ad-loading-sub">Running OCR if needed, then generating a clear NCERT-style explanation…</p>
    </div>
  </div>

  <c:set var="footerNote" value="NCERT Doubt Solver · Ask doubt" />
  <%@ include file="/WEB-INF/jsp/include/student/footer.jspf" %>

  <c:if test="${not empty chaptersBySubjectJson}">
    <script>
      window.NCERT_CHAPTERS_BY_SUBJECT = ${chaptersBySubjectJson};
    </script>
  </c:if>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="${ctx}/js/ask-doubt.js"></script>
</body>
</html>
