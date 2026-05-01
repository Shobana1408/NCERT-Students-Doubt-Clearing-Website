<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="adminNavActive" value="chapters" />
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Chapters — NCERT Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet" />
  <link href="${ctx}/css/admin-theme.css" rel="stylesheet" />
</head>
<body class="adm-body">
  <%@ include file="/WEB-INF/jsp/include/admin/sidebar.jspf" %>

  <div class="adm-main-wrap">
    <header class="adm-topbar d-flex align-items-center gap-3 flex-wrap">
      <button type="button" class="btn btn-light border d-lg-none" id="admSidebarToggle" aria-label="Open menu"><i class="bi bi-list"></i></button>
      <div class="flex-grow-1">
        <h1 class="adm-topbar-title mb-0">Manage chapters</h1>
        <p class="text-muted small mb-0 d-none d-sm-block">Chapters belong to a subject — used when students file doubts.</p>
      </div>
      <button type="button" class="btn btn-adm-primary" data-bs-toggle="modal" data-bs-target="#modalChapter">
        <i class="bi bi-plus-lg me-1"></i> Add chapter
      </button>
    </header>

    <main class="adm-content">
      <div class="adm-filter-bar adm-form mb-4">
        <form class="row g-3 align-items-end" method="get" action="${ctx}/admin/chapters">
          <div class="col-md-4 col-lg-3">
            <label class="form-label small fw-semibold mb-1" for="chSubject">Filter by subject</label>
            <select class="form-select" id="chSubject" name="subjectId">
              <option value="">All subjects</option>
              <c:forEach var="opt" items="${chapterFilterSubjects}">
                <option value="${opt.id}" <c:if test="${param.subjectId == opt.id}">selected="selected"</c:if>><c:out value="${opt.name}" /></option>
              </c:forEach>
            </select>
          </div>
          <div class="col-auto">
            <button type="submit" class="btn btn-adm-outline">Apply</button>
          </div>
        </form>
      </div>

      <div class="adm-table-card">
        <div class="table-responsive">
          <table class="table adm-table mb-0">
            <thead>
              <tr>
                <th class="ps-4">ID</th>
                <th>Subject</th>
                <th>#</th>
                <th>Title</th>
                <th class="text-end pe-4">Actions</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty chapterRows}">
                  <c:forEach var="ch" items="${chapterRows}">
                    <tr>
                      <td class="ps-4 font-monospace small text-muted"><c:out value="${ch.id}" /></td>
                      <td><span class="adm-badge-subject bg-primary bg-opacity-10 text-primary"><c:out value="${ch.subjectName}" /></span></td>
                      <td class="fw-semibold"><c:out value="${ch.chapterNumber}" /></td>
                      <td><c:out value="${ch.title}" /></td>
                      <td class="text-end pe-4">
                        <button type="button" class="btn btn-sm btn-light border" data-chapter-id="${ch.id}"><i class="bi bi-pencil"></i></button>
                        <button type="button" class="btn btn-sm btn-light border text-danger" data-chapter-id="${ch.id}"><i class="bi bi-trash"></i></button>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr><td colspan="5" class="ps-4 py-4 text-muted">No chapters — set <code>chapterRows</code> and optional <code>chapterFilterSubjects</code>.</td></tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </div>
    </main>
  </div>

  <div class="modal fade" id="modalChapter" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content border-0 shadow-lg adm-form">
        <div class="modal-header border-0 pb-0">
          <h2 class="modal-title h5 fw-bold">Add chapter</h2>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <form method="post" action="${not empty chapterSaveAction ? chapterSaveAction : '#'}">
          <div class="modal-body pt-2">
            <div class="mb-3">
              <label class="form-label small fw-semibold">Subject</label>
              <select class="form-select" name="subjectId" required>
                <c:forEach var="opt" items="${chapterFilterSubjects}">
                  <option value="${opt.id}"><c:out value="${opt.name}" /></option>
                </c:forEach>
              </select>
            </div>
            <div class="mb-3">
              <label class="form-label small fw-semibold">Chapter number</label>
              <input type="number" name="chapterNumber" class="form-control" min="1" value="1" />
            </div>
            <div class="mb-0">
              <label class="form-label small fw-semibold">Title</label>
              <input type="text" name="title" class="form-control" placeholder="Carbon and its Compounds" required />
            </div>
          </div>
          <div class="modal-footer border-0 pt-0">
            <button type="button" class="btn btn-adm-outline" data-bs-dismiss="modal">Cancel</button>
            <button type="submit" class="btn btn-adm-primary">Save chapter</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="${ctx}/js/admin.js"></script>
</body>
</html>
