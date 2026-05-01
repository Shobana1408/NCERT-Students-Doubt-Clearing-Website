<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="adminNavActive" value="dashboard" />
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Dashboard — NCERT Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet" />
  <link href="${ctx}/css/admin-theme.css" rel="stylesheet" />
</head>
<body class="adm-body">
  <%@ include file="/WEB-INF/jsp/include/admin/sidebar.jspf" %>

  <div class="adm-main-wrap">
    <header class="adm-topbar d-flex align-items-center gap-3">
      <button type="button" class="btn btn-light border d-lg-none" id="admSidebarToggle" aria-label="Open menu">
        <i class="bi bi-list"></i>
      </button>
      <div class="flex-grow-1">
        <h1 class="adm-topbar-title mb-0">Dashboard</h1>
        <p class="text-muted small mb-0 d-none d-sm-block">Overview of platform activity and health.</p>
      </div>
      <c:choose>
        <c:when test="${flaskApiOnline}">
          <span class="badge rounded-pill bg-success bg-opacity-10 text-success border border-success border-opacity-25">
            <i class="bi bi-circle-fill me-1" style="font-size: 0.5rem;"></i> Flask API online
          </span>
        </c:when>
        <c:otherwise>
          <span class="badge rounded-pill bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25">
            <i class="bi bi-circle-fill me-1" style="font-size: 0.5rem;"></i> Flask API offline
          </span>
        </c:otherwise>
      </c:choose>
    </header>

    <main class="adm-content">
      <div class="row g-3 g-xl-4 mb-4">
        <div class="col-sm-6 col-xl-3">
          <div class="adm-kpi-card">
            <div class="d-flex justify-content-between align-items-start mb-3">
              <div>
                <p class="adm-kpi-label mb-1">Total doubts</p>
                <p class="adm-kpi-value text-dark mb-0"><c:out value="${kpiTotalDoubts != null ? kpiTotalDoubts : '—'}" /></p>
              </div>
              <div class="adm-kpi-icon bg-primary bg-opacity-10 text-primary">
                <i class="bi bi-chat-dots-fill"></i>
              </div>
            </div>
            <p class="small text-success mb-0"><i class="bi bi-arrow-up-short"></i> <c:out value="${not empty kpiDoubtsGrowth ? kpiDoubtsGrowth : '—'}" /></p>
          </div>
        </div>
        <div class="col-sm-6 col-xl-3">
          <div class="adm-kpi-card">
            <div class="d-flex justify-content-between align-items-start mb-3">
              <div>
                <p class="adm-kpi-label mb-1">Total users</p>
                <p class="adm-kpi-value text-dark mb-0"><c:out value="${kpiTotalUsers != null ? kpiTotalUsers : '—'}" /></p>
              </div>
              <div class="adm-kpi-icon bg-info bg-opacity-10 text-info">
                <i class="bi bi-people-fill"></i>
              </div>
            </div>
            <p class="small text-muted mb-0">Registered students</p>
          </div>
        </div>
        <div class="col-sm-6 col-xl-3">
          <div class="adm-kpi-card">
            <div class="d-flex justify-content-between align-items-start mb-3">
              <div>
                <p class="adm-kpi-label mb-1">Most asked subject</p>
                <p class="adm-kpi-value text-dark mb-0"><c:out value="${not empty kpiTopSubject ? kpiTopSubject : '—'}" /></p>
              </div>
              <div class="adm-kpi-icon bg-warning bg-opacity-10 text-warning">
                <i class="bi bi-trophy-fill"></i>
              </div>
            </div>
            <p class="small text-muted mb-0"><c:out value="${not empty kpiTopSubjectMeta ? kpiTopSubjectMeta : '—'}" /></p>
          </div>
        </div>
        <div class="col-sm-6 col-xl-3">
          <div class="adm-kpi-card border-2" style="border-color: #fecaca !important;">
            <div class="d-flex justify-content-between align-items-start mb-3">
              <div>
                <p class="adm-kpi-label mb-1">Not helpful</p>
                <p class="adm-kpi-value text-danger mb-0"><c:out value="${kpiNotHelpfulCount != null ? kpiNotHelpfulCount : '—'}" /></p>
              </div>
              <div class="adm-kpi-icon bg-danger bg-opacity-10 text-danger">
                <i class="bi bi-hand-thumbs-down-fill"></i>
              </div>
            </div>
            <p class="small text-danger mb-0 fw-semibold"><i class="bi bi-exclamation-triangle me-1"></i> Review flagged answers</p>
          </div>
        </div>
      </div>

      <div class="row g-4">
        <div class="col-lg-7">
          <div class="adm-table-card p-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
              <h2 class="h5 fw-bold mb-0">Recent doubts</h2>
              <a href="${ctx}/admin/doubts" class="btn btn-sm btn-adm-outline">View all</a>
            </div>
            <div class="table-responsive">
              <table class="table adm-table mb-0">
                <thead>
                  <tr>
                    <th>Student</th>
                    <th>Subject</th>
                    <th>Preview</th>
                    <th>Time</th>
                  </tr>
                </thead>
                <tbody>
                  <c:choose>
                    <c:when test="${not empty recentGlobalDoubts}">
                      <c:forEach var="r" items="${recentGlobalDoubts}">
                        <tr>
                          <td class="fw-semibold"><c:out value="${r.studentName}" /></td>
                          <td>
                            <span class="adm-badge-subject bg-primary bg-opacity-10 text-primary">
                              <c:out value="${r.subjectName}" />
                            </span>
                          </td>
                          <td class="text-muted small"><c:out value="${r.preview}" /></td>
                          <td class="text-muted small"><c:out value="${r.timeAgo}" /></td>
                        </tr>
                      </c:forEach>
                    </c:when>
                    <c:otherwise>
                      <tr><td colspan="4" class="text-muted small">No recent doubts loaded — populate <code>recentGlobalDoubts</code> from the servlet.</td></tr>
                    </c:otherwise>
                  </c:choose>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        <div class="col-lg-5">
          <div class="adm-table-card p-4 mb-4">
            <h2 class="h5 fw-bold mb-3">Quick actions</h2>
            <div class="d-grid gap-2">
              <a href="${ctx}/admin/subjects" class="btn btn-adm-outline text-start d-flex align-items-center gap-2">
                <i class="bi bi-plus-circle text-primary"></i> Add subject
              </a>
              <a href="${ctx}/admin/chapters" class="btn btn-adm-outline text-start d-flex align-items-center gap-2">
                <i class="bi bi-plus-circle text-primary"></i> Add chapter
              </a>
              <a href="${ctx}/admin/feedback" class="btn btn-adm-outline text-start d-flex align-items-center gap-2">
                <i class="bi bi-flag text-danger"></i> Review not-helpful feedback
              </a>
            </div>
          </div>
          <div class="rounded-3 p-4 text-white" style="background: linear-gradient(135deg, #4f46e5, #7c3aed);">
            <h3 class="h6 fw-bold mb-2"><i class="bi bi-graph-up-arrow me-2"></i>Weekly snapshot</h3>
            <p class="small text-white-50 mb-0"><c:out value="${not empty adminSnapshotMessage ? adminSnapshotMessage : 'Connect analytics to show trends (image-based doubts, OCR accuracy, language mix).'}" /></p>
          </div>
        </div>
      </div>
    </main>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="${ctx}/js/admin.js"></script>
</body>
</html>
