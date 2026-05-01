<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="adminNavActive" value="doubts" />
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>All doubts — NCERT Admin</title>
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
        <h1 class="adm-topbar-title mb-0">All doubts</h1>
        <p class="text-muted small mb-0 d-none d-sm-block">Search and filter every student submission.</p>
      </div>
    </header>

    <main class="adm-content">
      <div class="adm-filter-bar adm-form mb-4">
        <form class="row g-3 align-items-end" method="get" action="${ctx}/admin/doubts">
          <div class="col-md-3 col-lg-2">
            <label class="form-label small fw-semibold mb-1" for="fSubject">Subject</label>
            <select class="form-select" id="fSubject" name="subject">
              <option value="">All subjects</option>
              <c:forEach var="s" items="${adminFilterSubjects}">
                <option value="<c:out value='${s}' />" <c:if test="${param.subject == s}">selected="selected"</c:if>><c:out value="${s}" /></option>
              </c:forEach>
            </select>
          </div>
          <div class="col-md-3 col-lg-2">
            <label class="form-label small fw-semibold mb-1" for="fChapter">Chapter</label>
            <select class="form-select" id="fChapter" name="chapter">
              <option value="">All chapters</option>
              <c:forEach var="cname" items="${adminFilterChapters}">
                <option value="<c:out value='${cname}' />" <c:if test="${param.chapter == cname}">selected="selected"</c:if>><c:out value="${cname}" /></option>
              </c:forEach>
            </select>
          </div>
          <div class="col-md-3 col-lg-2">
            <label class="form-label small fw-semibold mb-1" for="fType">Input type</label>
            <select class="form-select" id="fType" name="type">
              <option value="" <c:if test="${empty param.type}">selected="selected"</c:if>>Any</option>
              <option value="text" <c:if test="${param.type == 'text'}">selected="selected"</c:if>>Text</option>
              <option value="image" <c:if test="${param.type == 'image'}">selected="selected"</c:if>>Image</option>
            </select>
          </div>
          <div class="col-md-3 col-lg-3">
            <label class="form-label small fw-semibold mb-1" for="fSearch">Search</label>
            <input type="search" class="form-control" id="fSearch" name="q" placeholder="Question text…" value="<c:out value='${param.q}' />" />
          </div>
          <div class="col-auto">
            <button type="submit" class="btn btn-adm-primary"><i class="bi bi-funnel me-1"></i> Apply</button>
          </div>
        </form>
      </div>

      <div class="adm-table-card">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 px-3 py-3 border-bottom bg-white">
          <p class="small text-muted mb-0">
            <strong><c:out value="${adminDoubtTotal != null ? adminDoubtTotal : '0'}" /></strong> doubts
            <c:if test="${not empty adminDoubtRangeLabel}"> · <c:out value="${adminDoubtRangeLabel}" /></c:if>
          </p>
          <button type="button" class="btn btn-sm btn-adm-outline"><i class="bi bi-download me-1"></i> Export CSV</button>
        </div>
        <div class="table-responsive">
          <table class="table adm-table mb-0">
            <thead>
              <tr>
                <th>ID</th>
                <th>Student</th>
                <th>Subject</th>
                <th>Chapter</th>
                <th>Question</th>
                <th>Type</th>
                <th>Lang</th>
                <th>Created</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty adminDoubtRows}">
                  <c:forEach var="d" items="${adminDoubtRows}">
                    <tr>
                      <td class="font-monospace small text-muted">#<c:out value="${d.id}" /></td>
                      <td class="fw-semibold"><c:out value="${d.studentEmail}" /></td>
                      <td><span class="adm-badge-subject bg-primary bg-opacity-10 text-primary"><c:out value="${d.subjectName}" /></span></td>
                      <td class="small"><c:out value="${d.chapterTitle}" /></td>
                      <td class="small text-muted" style="max-width: 220px;"><c:out value="${d.questionPreview}" /></td>
                      <td>
                        <c:choose>
                          <c:when test="${d.imageBased}">
                            <span class="badge rounded-pill bg-secondary bg-opacity-15 text-dark"><i class="bi bi-image me-1"></i>Image</span>
                          </c:when>
                          <c:otherwise>
                            <span class="badge rounded-pill bg-light text-dark border"><i class="bi bi-keyboard me-1"></i>Text</span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td><span class="badge rounded-pill bg-light text-dark border"><c:out value="${d.languageCode}" /></span></td>
                      <td class="small text-muted"><c:out value="${d.createdAt}" /></td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr><td colspan="8" class="py-4 text-muted small">No rows — set <code>adminDoubtRows</code> from the servlet.</td></tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
        <c:if test="${not empty adminDoubtPage and not empty adminDoubtTotalPages}">
          <div class="d-flex justify-content-between align-items-center px-3 py-3 border-top bg-light">
            <span class="small text-muted">Page <c:out value="${adminDoubtPage}" /> of <c:out value="${adminDoubtTotalPages}" /></span>
            <nav>
              <ul class="pagination pagination-sm mb-0">
                <li class="page-item ${adminDoubtPage <= 1 ? 'disabled' : ''}">
                  <a class="page-link border-0 bg-transparent" href="${ctx}/admin/doubts?page=${adminDoubtPage - 1}&amp;q=${param.q}&amp;subject=${param.subject}&amp;chapter=${param.chapter}&amp;type=${param.type}">Prev</a>
                </li>
                <li class="page-item ${adminDoubtPage >= adminDoubtTotalPages ? 'disabled' : ''}">
                  <a class="page-link border-0 bg-transparent" href="${ctx}/admin/doubts?page=${adminDoubtPage + 1}&amp;q=${param.q}&amp;subject=${param.subject}&amp;chapter=${param.chapter}&amp;type=${param.type}">Next</a>
                </li>
              </ul>
            </nav>
          </div>
        </c:if>
      </div>
    </main>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="${ctx}/js/admin.js"></script>
</body>
</html>
