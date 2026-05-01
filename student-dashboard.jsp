<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="Dashboard — NCERT Doubt Solver" />
<c:set var="studentNavActive" value="dashboard" />
<c:set var="studentDisplayName" value="${not empty studentDisplayName ? studentDisplayName : (not empty sessionScope.studentDisplayName ? sessionScope.studentDisplayName : '')}" />
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/jsp/include/student/head.jspf" %>
</head>
<body class="nc-page d-flex flex-column">
  <%@ include file="/WEB-INF/jsp/include/student/navbar.jspf" %>

  <div class="container-fluid px-0 flex-grow-1">
    <div class="row g-0">
      <%@ include file="/WEB-INF/jsp/include/student/sidebar.jspf" %>
      <div class="col-lg-9 col-xl-10 p-4 p-lg-5 nc-dashboard-main">
        <header class="mb-4 mb-lg-5">
          <p class="nc-eyebrow"><c:out value="${not empty greeting ? greeting : 'Welcome'}" /></p>
          <h1 class="nc-title-h1 mb-0">
            <c:out value="${not empty studentFirstName ? studentFirstName : 'Student'}" />
            <c:if test="${not empty studentLastName}">
              <span class="text-gradient"><c:out value="${studentLastName}" /></span>
            </c:if>
          </h1>
        </header>

        <div class="nc-hero-card nc-card p-4 p-md-5 mb-4 mb-lg-5">
          <div class="row align-items-center gy-3">
            <div class="col-md-8">
              <span class="nc-badge-soft mb-3 d-inline-block"><i class="bi bi-stars me-1"></i> Ready when you are</span>
              <h2 class="fw-bold mt-0 mb-2">What would you like to learn today?</h2>
              <p class="text-muted mb-0 pe-lg-3">Ask in text or upload a question image — get answers, steps, and simple explanations in your language.</p>
            </div>
            <div class="col-md-4 text-md-end pt-2 pt-md-0">
              <a href="${ctx}/student/ask" class="btn btn-nc-primary btn-lg px-4"><i class="bi bi-plus-lg me-1"></i> New doubt</a>
            </div>
          </div>
        </div>

        <div class="row g-3 g-md-4 mb-4 mb-lg-5">
          <div class="col-sm-6 col-xl-3">
            <div class="nc-stat-card nc-stat-card--blue h-100">
              <div class="d-flex justify-content-between align-items-start mb-2">
                <span class="text-muted small fw-semibold">Doubts asked</span>
                <span class="nc-card-icon bg-primary bg-opacity-10 text-primary"><i class="bi bi-chat-dots"></i></span>
              </div>
              <p class="display-6 fw-bold mb-0"><c:out value="${statsDoubtsTotal != null ? statsDoubtsTotal : '0'}" /></p>
              <p class="small text-success mb-0 mt-1"><i class="bi bi-arrow-up-short"></i> <c:out value="${statsDoubtsThisWeek != null ? statsDoubtsThisWeek : '0'}" /> this week</p>
            </div>
          </div>
          <div class="col-sm-6 col-xl-3">
            <div class="nc-stat-card nc-stat-card--emerald h-100">
              <div class="d-flex justify-content-between align-items-start mb-2">
                <span class="text-muted small fw-semibold">Subjects</span>
                <span class="nc-card-icon bg-success bg-opacity-10 text-success"><i class="bi bi-book"></i></span>
              </div>
              <p class="display-6 fw-bold mb-0"><c:out value="${statsSubjectCount != null ? statsSubjectCount : '0'}" /></p>
              <p class="small text-muted mb-0 mt-1"><c:out value="${not empty statsSubjectsSubtitle ? statsSubjectsSubtitle : '—'}" /></p>
            </div>
          </div>
          <div class="col-sm-6 col-xl-3">
            <div class="nc-stat-card nc-stat-card--amber h-100">
              <div class="d-flex justify-content-between align-items-start mb-2">
                <span class="text-muted small fw-semibold">Helpful rate</span>
                <span class="nc-card-icon bg-warning bg-opacity-10 text-warning"><i class="bi bi-hand-thumbs-up"></i></span>
              </div>
              <p class="display-6 fw-bold mb-0"><c:out value="${statsHelpfulRate != null ? statsHelpfulRate : '—'}" /></p>
              <p class="small text-muted mb-0 mt-1">From your feedback</p>
            </div>
          </div>
          <div class="col-sm-6 col-xl-3">
            <div class="nc-stat-card nc-stat-card--violet h-100">
              <div class="d-flex justify-content-between align-items-start mb-2">
                <span class="text-muted small fw-semibold">Languages</span>
                <span class="nc-card-icon bg-info bg-opacity-10 text-info"><i class="bi bi-translate"></i></span>
              </div>
              <p class="display-6 fw-bold mb-0"><c:out value="${statsLanguagesCount != null ? statsLanguagesCount : '0'}" /></p>
              <p class="small text-muted mb-0 mt-1"><c:out value="${not empty statsLanguagesLabel ? statsLanguagesLabel : '—'}" /></p>
            </div>
          </div>
        </div>

        <div class="row g-4 align-items-stretch">
          <div class="col-lg-7">
            <div class="nc-card nc-card--elevated p-4 p-lg-4 h-100">
              <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="nc-section-title mb-0"><i class="bi bi-clock-history"></i> Recent activity</h3>
                <a href="${ctx}/student/history" class="nc-link-muted">View all</a>
              </div>
              <c:choose>
                <c:when test="${not empty recentDoubts}">
                  <div class="list-group list-group-flush">
                    <c:forEach var="d" items="${recentDoubts}">
                      <a href="${not empty d.resultUrl ? d.resultUrl : ctx.concat('/student/history')}" class="list-group-item list-group-item-action nc-recent-item d-flex gap-3">
                        <div class="nc-recent-icon">
                          <c:choose>
                            <c:when test="${d.imageBased}"><i class="bi bi-image fs-4"></i></c:when>
                            <c:otherwise><i class="bi bi-keyboard fs-4"></i></c:otherwise>
                          </c:choose>
                        </div>
                        <div class="flex-grow-1 min-w-0">
                          <p class="fw-semibold mb-1 text-truncate"><c:out value="${d.title}" /></p>
                          <p class="small text-muted mb-0"><c:out value="${d.subjectLabel}" /> · <c:out value="${d.timeAgo}" /></p>
                        </div>
                        <span class="badge rounded-pill bg-success bg-opacity-10 text-success border border-success border-opacity-25 align-self-center px-3 py-2"><c:out value="${not empty d.status ? d.status : 'Done'}" /></span>
                      </a>
                    </c:forEach>
                  </div>
                </c:when>
                <c:otherwise>
                  <p class="text-muted mb-0">No recent doubts yet. <a href="${ctx}/student/ask" class="fw-semibold">Ask your first doubt</a>.</p>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
          <div class="col-lg-5">
            <div class="nc-card nc-card--elevated p-4 h-100">
              <h3 class="nc-section-title mb-4"><i class="bi bi-lightning-charge text-warning"></i> Shortcuts</h3>
              <div class="d-grid gap-2 nc-shortcut-stack">
                <a href="${ctx}/student/ask" class="btn btn-nc-outline text-start d-flex align-items-center gap-2">
                  <i class="bi bi-pencil-square text-primary"></i> Type a doubt
                </a>
                <a href="${ctx}/student/ask" class="btn btn-nc-outline text-start d-flex align-items-center gap-2">
                  <i class="bi bi-camera text-primary"></i> Upload question image
                </a>
                <a href="${ctx}/student/history" class="btn btn-nc-outline text-start d-flex align-items-center gap-2">
                  <i class="bi bi-archive text-primary"></i> Browse history
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <c:set var="footerNote" value="NCERT Doubt Solver · Dashboard" />
  <%@ include file="/WEB-INF/jsp/include/student/footer.jspf" %>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="${ctx}/js/app.js"></script>
</body>
</html>
