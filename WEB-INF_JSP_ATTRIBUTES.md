# JSP request and session attributes (NCERT Doubt Solver)

This document lists **request attributes** (`request.setAttribute(...)`) and **session attributes** your servlets should set **before** forwarding to each JSP. Names follow what the JSP EL expects (e.g. `${subjectList}`).

Static assets live under the webapp root: `${pageContext.request.contextPath}/css/`, `/js/`.

---

## Servlets and URLs

| Servlet | URL pattern | Role |
|--------|-------------|------|
| `StudentViewServlet` | `/student/*` | Student UI (login, dashboard, ask, history). |
| `DoubtSubmitServlet` | `/student/doubt/submit` | GET → ask form; POST → multipart doubt → result JSP. |
| `AdminViewServlet` | `/admin/*` | Admin UI. |

Exact mapping `/student/doubt/submit` takes precedence over `/student/*` for that path.

---

## Student: `student-login.jsp`

| Scope | Attribute | Description |
|-------|-------------|-------------|
| Request | `loginError` | Optional error message after failed login. |
| Request | `loginFormAction` | Optional form `action` URL (defaults to `#`). |

**Session:** After successful login, set e.g. `studentDisplayName`, `studentId` (your model).

---

## Student: `student-register.jsp`

| Scope | Attribute | Description |
|-------|-------------|-------------|
| Request | `registerError` | Optional validation or server error. |
| Request | `registerFormAction` | Optional POST target (defaults to `#`). |

---

## Student: `student-dashboard.jsp`

| Scope | Attribute | Description |
|-------|-------------|-------------|
| Request or session | `studentDisplayName` | Shown in navbar dropdown. |
| Request | `greeting` | e.g. “Good afternoon,” |
| Request | `studentFirstName`, `studentLastName` | Heading name parts. |
| Request | `statsDoubtsTotal`, `statsDoubtsThisWeek`, `statsSubjectCount`, `statsSubjectsSubtitle`, `statsHelpfulRate`, `statsLanguagesCount`, `statsLanguagesLabel` | Dashboard stat cards. |
| Request | `recentDoubts` | **Collection** of row objects (see below). |

**`recentDoubts` row (beans or maps):**

- `title` — line of text for the doubt.
- `subjectLabel` — subject name.
- `timeAgo` — relative time string.
- `status` — optional badge text (default “Done”).
- `imageBased` — boolean; icon keyboard vs image.
- `resultUrl` — optional link target for the row (defaults to history).

---

## Student: `ask-doubt.jsp` (also used by `DoubtSubmitServlet` GET)

| Scope | Attribute | Description |
|-------|-------------|-------------|
| Request | `subjectList` | Optional **collection** of subjects with `name` (and optional `id`, `code`). If empty, static demo options are used. |
| Request | `formError` | Optional message when re-displaying the form after validation failure. |
| Request | `chaptersBySubjectJson` | **Optional.** Trusted JSON object literal for `window.NCERT_CHAPTERS_BY_SUBJECT` (same shape as in `ask-doubt.js`: subject name → array of chapter title strings). Must be **valid JSON** produced server-side (e.g. Jackson); do not concatenate untrusted text into this script. |

**Form:** POST to `${contextPath}/student/doubt/submit` with `multipart/form-data`, fields: `class`, `subject`, `chapter`, `language`, `question`, file part `image`.

---

## Student: `doubt-history.jsp`

| Scope | Attribute | Description |
|-------|-------------|-------------|
| Request | `doubtHistory` | **Collection** of history rows. |
| Request | `historySubjectOptions` | Optional list of subject name strings for the filter. |
| Request | `historyPage`, `historyTotalPages` | Optional pagination; enables Prev/Next bar. |

**History row:**

- `title`, `ocrPreview`, `subjectName`, `languageCode`, `createdAt`, `feedback` (`helpful` \| `not_helpful` \| other), `imageBased`, `resultUrl`.

Query params used: `q`, `subject`, `sort` (`newest` \| `oldest`).

---

## Student: `doubt-result.jsp` (used by `DoubtSubmitServlet` POST)

Set by `DoubtSubmitServlet` today:

| Request attribute | Constant / source | Description |
|--------------------|-------------------|-------------|
| `errorMessage` | `ATTR_ERROR_MESSAGE` | Validation or integration error. |
| `extractedText` | `ATTR_EXTRACTED_TEXT` | OCR text from image (if any). |
| `questionUsed` | `ATTR_QUESTION_USED` | Final question text sent to AI. |
| `aiResult` | `ATTR_AI_RESULT` | `AiApiResponse` bean (`answer`, `stepByStep`, `simpleExplanation`, `translatedResponse`, `success`, `error`). |

Also set on POST (form context):

| Request attribute | Constant | Description |
|-------------------|----------|-------------|
| `doubtSubject` | `ATTR_DOUBT_SUBJECT` | Subject from form. |
| `doubtChapter` | `ATTR_DOUBT_CHAPTER` | Chapter from form. |
| `doubtLanguage` | `ATTR_DOUBT_LANGUAGE` | Language code. |
| `doubtClass` | `ATTR_DOUBT_CLASS` | Class / grade from form (`name="class"`). |

Optional (your servlet may add):

| Request attribute | Description |
|-------------------|-------------|
| `languageLabel` | Human-readable language for the subtitle/badge. |
| `translationLabel`, `translationLang` | Label and `lang` for translated block. |
| `resultStatusLabel` | Badge text (default “Solved”). |

---

## Admin: `admin-login.jsp`

| Request | `adminLoginError`, `adminLoginFormAction` | Same pattern as student login. |

---

## Admin: `admin-dashboard.jsp`

| Request | Description |
|---------|-------------|
| `flaskApiOnline` | Boolean; health of Flask microservice. |
| `kpiTotalDoubts`, `kpiDoubtsGrowth`, `kpiTotalUsers`, `kpiTopSubject`, `kpiTopSubjectMeta`, `kpiNotHelpfulCount` | KPI strings/numbers. |
| `recentGlobalDoubts` | Rows: `studentName`, `subjectName`, `preview`, `timeAgo`. |
| `adminSnapshotMessage` | Weekly snapshot paragraph. |

---

## Admin: `admin-subjects.jsp`

| Request | Description |
|---------|-------------|
| `subjectRows` | Rows: `id`, `name`, `code`, `gradeLabel`, `chapterCount`. |
| `subjectSaveAction` | Optional POST URL for the “Add subject” modal. |

---

## Admin: `admin-chapters.jsp`

| Request | Description |
|---------|-------------|
| `chapterFilterSubjects` | List for filter + modal: items with `id`, `name`. |
| `chapterRows` | Rows: `id`, `subjectName`, `chapterNumber`, `title`. |
| `chapterSaveAction` | Optional POST URL for add chapter. |

---

## Admin: `admin-doubts.jsp`

| Request | Description |
|---------|-------------|
| `adminFilterSubjects`, `adminFilterChapters` | String lists for filters. |
| `adminDoubtTotal`, `adminDoubtRangeLabel`, `adminDoubtPage`, `adminDoubtTotalPages` | Summary + pagination. |
| `adminDoubtRows` | Rows: `id`, `studentEmail`, `subjectName`, `chapterTitle`, `questionPreview`, `imageBased`, `languageCode`, `createdAt`. |

---

## Admin: `admin-answers-feedback.jsp`

| Request | Description |
|---------|-------------|
| `notHelpfulCount` | Number for alert banner. |
| `feedbackFilterSubjects`, `feedbackFilterChapters` | String lists. |
| `feedbackRows` | Rows: `doubtId`, `subjectName`, `chapterTitle`, `answerPreview`, `feedback` (`helpful` \| `not_helpful` \| other), `createdAt`. |

---

## Session suggestions (both apps)

- **Student:** `studentId`, `studentDisplayName`, `studentEmail` (or your `User` object).
- **Admin:** `adminUser`, `adminRole`, or similar; enforce in a `Filter` before `/admin/*` except `/admin/login`.

---

## JSTL

All JSPs use `<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>`. Ensure **JSTL 1.2** is on the classpath (already in `pom.xml` for this project).
