<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="adminNavActive" value="feedback" />
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Answers &amp; feedback — NCERT Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet" />
  <link href="${ctx}/css/admin-theme.css" rel="stylesheet" />
</head>
<body class="adm-body">
  <%@ include file="/WEB-INF/jsp/include/admin/sidebar.jspf" %>

  <div class="adm-main-wrap">
    <header class="adm-topbar d-flex align-items-center gap-3">
      <button type="button" class="btn btn-light border d-lg-none" id="admSidebarToggle" aria-label="Open menu"><i class="bi bi-list"></i></button>
      <div class="flex-grow-1">
        <h1 class="adm-topbar-title mb-0">Answers &amp; feedback</h1>
        <p class="text-muted small mb-0 d-none d-sm-block">Audit AI responses and student ratings.</p>
      </div>
    </header>

    <main class="adm-content">
      <div class="alert alert-warning border-0 shadow-sm d-flex align-items-start gap-3 mb-4" role="alert">
        <div class="rounded-circle bg-warning bg-opacity-25 p-2 text-warning">
          <i class="bi bi-exclamation-triangle-fill"></i>
        </div>
        <div>
          <strong><c:out value="${notHelpfulCount != null ? notHelpfulCount : '—'}" /> not-helpful</strong> responses logged.
          Filter with <code>is_helpful = false</code> in your persistence layer when wiring this page.
        </div>
      </div>

      <div class="adm-filter-bar adm-form mb-4">
        <form class="row g-3 align-items-end" method="get" action="${ctx}/admin/feedback">
          <div class="col-md-3 col-lg-2">
            <label class="form-label small fw-semibold mb-1" for="sSubject">Subject</label>
            <select class="form-select" id="sSubject" name="subject">
              <option value="">All subjects</option>
              <c:forEach var="s" items="${feedbackFilterSubjects}">
                <option value="<c:out value='${s}' />" <c:if test="${param.subject == s}">selected="selected"</c:if>><c:out value="${s}" /></option>
              </c:forEach>
            </select>
          </div>
          <div class="col-md-3 col-lg-2">
            <label class="form-label small fw-semibold mb-1" for="sChapter">Chapter</label>
            <select class="form-select" id="sChapter" name="chapter">
              <option value="">All chapters</option>
              <c:forEach var="cname" items="${feedbackFilterChapters}">
                <option value="<c:out value='${cname}' />" <c:if test="${param.chapter == cname}">selected="selected"</c:if>><c:out value="${cname}" /></option>
              </c:forEach>
            </select>
          </div>
          <div class="col-md-3 col-lg-2">
            <label class="form-label small fw-semibold mb-1" for="sFeedback">Feedback</label>
            <select class="form-select" id="sFeedback" name="feedback">
              <option value="" <c:if test="${empty param.feedback}">selected="selected"</c:if>>All</option>
              <option value="not" <c:if test="${param.feedback == 'not'}">selected="selected"</c:if>>Not helpful only</option>
              <option value="yes" <c:if test="${param.feedback == 'yes'}">selected="selected"</c:if>>Helpful only</option>
              <option value="none" <c:if test="${param.feedback == 'none'}">selected="selected"</c:if>>No feedback yet</option>
            </select>
          </div>
          <div class="col-auto ms-auto">
            <button type="submit" class="btn btn-adm-primary"><i class="bi bi-funnel me-1"></i> Apply filters</button>
          </div>
        </form>
      </div>

      <div class="adm-table-card">
        <div class="table-responsive">
          <table class="table adm-table mb-0">
            <thead>
              <tr>
                <th>Doubt ID</th>
                <th>Subject / Chapter</th>
                <th>Answer preview</th>
                <th>Student feedback</th>
                <th>Date</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty feedbackRows}">
                  <c:forEach var="f" items="${feedbackRows}">
                    <tr class="${f.feedback == 'not_helpful' ? 'adm-row-alert' : ''}">
                      <td class="font-monospace small">#<c:out value="${f.doubtId}" /></td>
                      <td>
                        <span class="adm-badge-subject bg-primary bg-opacity-10 text-primary d-block mb-1 adm-w-fit"><c:out value="${f.subjectName}" /></span>
                        <span class="small text-muted"><c:out value="${f.chapterTitle}" /></span>
                      </td>
                      <td class="small text-muted" style="max-width: 280px;"><c:out value="${f.answerPreview}" /></td>
                      <td>
                        <c:choose>
                          <c:when test="${f.feedback == 'not_helpful'}">
                            <span class="adm-badge-not-helpful rounded-pill px-3 py-2 d-inline-flex align-items-center gap-1">
                              <i class="bi bi-hand-thumbs-down-fill"></i> Not helpful
                            </span>
                          </c:when>
                          <c:when test="${f.feedback == 'helpful'}">
                            <span class="adm-badge-helpful rounded-pill px-3 py-2 d-inline-flex align-items-center gap-1">
                              <i class="bi bi-hand-thumbs-up-fill"></i> Helpful
                            </span>
                          </c:when>
                          <c:otherwise>
                            <span class="adm-badge-neutral rounded-pill px-3 py-2 d-inline-flex align-items-center gap-1">
                              <i class="bi bi-dash-circle"></i> No feedback
                            </span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td class="small text-muted"><c:out value="${f.createdAt}" /></td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr><td colspan="5" class="py-4 text-muted small">No rows — set <code>feedbackRows</code> (and optional filter lists).</td></tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </div>
    </main>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="${ctx}/js/admin.js"></script>
</body>
</html>
