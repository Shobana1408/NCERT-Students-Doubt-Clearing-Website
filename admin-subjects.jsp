<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="adminNavActive" value="subjects" />
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Subjects — NCERT Admin</title>
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
        <h1 class="adm-topbar-title mb-0">Manage subjects</h1>
        <p class="text-muted small mb-0 d-none d-sm-block">NCERT-aligned subject catalogue for doubt routing.</p>
      </div>
      <button type="button" class="btn btn-adm-primary" data-bs-toggle="modal" data-bs-target="#modalSubject">
        <i class="bi bi-plus-lg me-1"></i> Add subject
      </button>
    </header>

    <main class="adm-content">
      <div class="adm-table-card">
        <div class="table-responsive">
          <table class="table adm-table mb-0">
            <thead>
              <tr>
                <th class="ps-4">ID</th>
                <th>Name</th>
                <th>Code</th>
                <th>Grade</th>
                <th>Chapters</th>
                <th class="text-end pe-4">Actions</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty subjectRows}">
                  <c:forEach var="s" items="${subjectRows}">
                    <tr>
                      <td class="ps-4 font-monospace small text-muted"><c:out value="${s.id}" /></td>
                      <td class="fw-semibold"><c:out value="${s.name}" /></td>
                      <td><span class="badge rounded-pill bg-light text-dark border font-monospace"><c:out value="${s.code}" /></span></td>
                      <td><span class="badge bg-secondary bg-opacity-10 text-secondary"><c:out value="${s.gradeLabel}" /></span></td>
                      <td class="small text-muted"><c:out value="${s.chapterCount}" /></td>
                      <td class="text-end pe-4">
                        <button type="button" class="btn btn-sm btn-light border" title="Edit" data-subject-id="${s.id}"><i class="bi bi-pencil"></i></button>
                        <button type="button" class="btn btn-sm btn-light border text-danger" title="Delete" data-subject-id="${s.id}"><i class="bi bi-trash"></i></button>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr><td colspan="6" class="ps-4 py-4 text-muted">No subjects — set request attribute <code>subjectRows</code> (list of beans with id, name, code, gradeLabel, chapterCount).</td></tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </div>
    </main>
  </div>

  <div class="modal fade" id="modalSubject" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content border-0 shadow-lg adm-form">
        <div class="modal-header border-0 pb-0">
          <h2 class="modal-title h5 fw-bold">Add subject</h2>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <form method="post" action="${not empty subjectSaveAction ? subjectSaveAction : '#'}">
          <div class="modal-body pt-2">
            <div class="mb-3">
              <label class="form-label small fw-semibold">Name</label>
              <input type="text" name="name" class="form-control" placeholder="e.g. English" required />
            </div>
            <div class="mb-3">
              <label class="form-label small fw-semibold">Code</label>
              <input type="text" name="code" class="form-control font-monospace" placeholder="ENG-10" required />
            </div>
            <div class="mb-0">
              <label class="form-label small fw-semibold">Grade</label>
              <input type="text" name="gradeLabel" class="form-control" placeholder="Class 10" />
            </div>
          </div>
          <div class="modal-footer border-0 pt-0">
            <button type="button" class="btn btn-adm-outline" data-bs-dismiss="modal">Cancel</button>
            <button type="submit" class="btn btn-adm-primary">Save subject</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="${ctx}/js/admin.js"></script>
</body>
</html>
