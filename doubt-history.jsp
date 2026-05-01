<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="Doubt history — NCERT Doubt Solver" />
<c:set var="studentNavActive" value="history" />
<c:set var="studentDisplayName" value="${not empty studentDisplayName ? studentDisplayName : sessionScope.studentDisplayName}" />
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/jsp/include/student/head.jspf" %>
</head>
<body class="nc-page d-flex flex-column">
  <%@ include file="/WEB-INF/jsp/include/student/navbar.jspf" %>

  <main class="nc-main flex-grow-1 py-4 py-lg-5">
    <div class="container-fluid px-3 px-lg-4" style="max-width: 1100px;">
      <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4 mb-lg-5">
        <div>
          <p class="nc-eyebrow mb-2">Your learning trail</p>
          <h1 class="nc-title-h1 mb-2"><i class="bi bi-journals text-primary me-2"></i>Doubt history</h1>
          <p class="text-muted mb-0">Review past questions, OCR text, and answers anytime.</p>
        </div>
        <a href="${ctx}/student/ask" class="btn btn-nc-primary px-4"><i class="bi bi-plus-lg me-1"></i> New doubt</a>
      </div>

      <div class="nc-card nc-card--elevated p-3 p-md-4 mb-4">
        <form class="row g-3 align-items-end" method="get" action="${ctx}/student/history">
          <div class="col-md-4">
            <label class="form-label small fw-semibold mb-1" for="fSearch">Search</label>
            <div class="input-group">
              <span class="input-group-text bg-light border-end-0 rounded-start-3"><i class="bi bi-search text-muted"></i></span>
              <input type="search" class="form-control border-start-0 rounded-end-3" id="fSearch" name="q" placeholder="Keyword in question…" value="<c:out value='${param.q}' />" />
            </div>
          </div>
          <div class="col-md-3">
            <label class="form-label small fw-semibold mb-1" for="fSubject">Subject</label>
            <select class="form-select" id="fSubject" name="subject">
              <option value="">All subjects</option>
              <c:forEach var="subj" items="${historySubjectOptions}">
                <option value="<c:out value='${subj}' />" ${param.subject == subj ? 'selected' : ''}><c:out value="${subj}" /></option>
              </c:forEach>
              <c:if test="${empty historySubjectOptions}">
                <option value="Science" ${param.subject == 'Science' ? 'selected' : ''}>Science</option>
                <option value="Mathematics" ${param.subject == 'Mathematics' ? 'selected' : ''}>Mathematics</option>
                <option value="Social Science" ${param.subject == 'Social Science' ? 'selected' : ''}>Social Science</option>
              </c:if>
            </select>
          </div>
          <div class="col-md-3">
            <label class="form-label small fw-semibold mb-1" for="fSort">Sort</label>
            <select class="form-select" id="fSort" name="sort">
              <option value="newest" ${empty param.sort or param.sort == 'newest' ? 'selected' : ''}>Newest first</option>
              <option value="oldest" ${param.sort == 'oldest' ? 'selected' : ''}>Oldest first</option>
            </select>
          </div>
          <div class="col-md-2">
            <button type="submit" class="btn btn-nc-outline w-100">Apply</button>
          </div>
        </form>
      </div>

      <div class="nc-table-wrap bg-white">
        <div class="table-responsive">
          <table class="table nc-table table-hover align-middle mb-0">
            <thead class="small text-muted text-uppercase">
              <tr>
                <th class="ps-4">Question</th>
                <th>Subject</th>
                <th>Language</th>
                <th>Date</th>
                <th>Feedback</th>
                <th class="pe-4 text-end">Action</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty doubtHistory}">
                  <c:forEach var="h" items="${doubtHistory}">
                    <tr>
                      <td class="ps-4">
                        <div class="fw-semibold text-truncate" style="max-width: 280px;"><c:out value="${h.title}" /></div>
                        <div class="small text-muted text-truncate" style="max-width: 280px;">
                          <c:choose>
                            <c:when test="${h.imageBased}">
                              <i class="bi bi-image me-1"></i>OCR: <c:out value="${h.ocrPreview}" />
                            </c:when>
                            <c:otherwise>
                              <i class="bi bi-keyboard me-1"></i>Typed question
                            </c:otherwise>
                          </c:choose>
                        </div>
                      </td>
                      <td><span class="badge bg-primary bg-opacity-10 text-primary rounded-pill"><c:out value="${h.subjectName}" /></span></td>
                      <td><c:out value="${h.languageCode}" /></td>
                      <td class="small text-muted"><c:out value="${h.createdAt}" /></td>
                      <td>
                        <c:choose>
                          <c:when test="${h.feedback == 'helpful'}">
                            <span class="badge bg-success bg-opacity-10 text-success"><i class="bi bi-hand-thumbs-up me-1"></i>Helpful</span>
                          </c:when>
                          <c:when test="${h.feedback == 'not_helpful'}">
                            <span class="badge bg-danger bg-opacity-10 text-danger"><i class="bi bi-hand-thumbs-down me-1"></i>Not helpful</span>
                          </c:when>
                          <c:otherwise>
                            <span class="badge bg-secondary bg-opacity-10 text-secondary">—</span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td class="pe-4 text-end">
                        <a href="${not empty h.resultUrl ? h.resultUrl : ctx.concat('/student/history')}" class="btn btn-sm btn-nc-outline">Open</a>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="6" class="ps-4 py-4 text-muted">No history yet. <a href="${ctx}/student/ask" class="fw-semibold">Ask a doubt</a>.</td>
                  </tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </div>

      <c:if test="${not empty historyTotalPages and historyTotalPages > 1}">
        <nav class="mt-4 d-flex justify-content-center align-items-center gap-3" aria-label="History pagination">
          <c:set var="prevPage" value="${historyPage > 1 ? historyPage - 1 : 1}" />
          <c:set var="nextPage" value="${historyPage < historyTotalPages ? historyPage + 1 : historyTotalPages}" />
          <a class="btn btn-sm btn-nc-outline ${historyPage <= 1 ? 'disabled' : ''}" href="${ctx}/student/history?page=${prevPage}&amp;q=${param.q}&amp;subject=${param.subject}&amp;sort=${param.sort}">Prev</a>
          <span class="small text-muted">Page <c:out value="${historyPage}" /> / <c:out value="${historyTotalPages}" /></span>
          <a class="btn btn-sm btn-nc-outline ${historyPage >= historyTotalPages ? 'disabled' : ''}" href="${ctx}/student/history?page=${nextPage}&amp;q=${param.q}&amp;subject=${param.subject}&amp;sort=${param.sort}">Next</a>
        </nav>
      </c:if>
    </div>
  </main>

  <c:set var="footerNote" value="NCERT Doubt Solver · History" />
  <%@ include file="/WEB-INF/jsp/include/student/footer.jspf" %>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="${ctx}/js/app.js"></script>
</body>
</html>
