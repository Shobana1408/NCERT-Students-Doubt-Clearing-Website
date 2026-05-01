/**
 * NCERT Doubt Solver — shared UI behaviour
 */

(function () {
  "use strict";

  function initImagePreview() {
    var input = document.getElementById("questionImage");
    var preview = document.getElementById("imagePreview");
    var placeholder = document.getElementById("dropzonePlaceholder");
    var dropzone = document.getElementById("dropzone");
    var previewContainer = document.getElementById("previewContainer");
    var clearBtn = document.getElementById("btnClearImage");

    if (!input || !preview || !dropzone) return;

    function resetPreview() {
      preview.src = "";
      preview.classList.add("d-none");
      if (previewContainer) previewContainer.classList.add("d-none");
      if (clearBtn) clearBtn.classList.add("d-none");
      if (placeholder) placeholder.classList.remove("d-none");
      input.value = "";
    }

    function showPreview(file) {
      if (!file || !file.type.match(/^image\//)) return;
      var reader = new FileReader();
      reader.onload = function (e) {
        preview.src = e.target.result;
        preview.classList.remove("d-none");
        if (previewContainer) previewContainer.classList.remove("d-none");
        if (clearBtn) clearBtn.classList.remove("d-none");
        if (placeholder) placeholder.classList.add("d-none");
      };
      reader.readAsDataURL(file);
    }

    input.addEventListener("change", function () {
      if (input.files && input.files[0]) {
        showPreview(input.files[0]);
      } else {
        resetPreview();
      }
    });

    ["dragenter", "dragover", "dragleave", "drop"].forEach(function (ev) {
      dropzone.addEventListener(ev, function (e) {
        e.preventDefault();
        e.stopPropagation();
      });
    });

    ["dragenter", "dragover"].forEach(function (ev) {
      dropzone.addEventListener(ev, function () {
        dropzone.classList.add("dragover");
      });
    });

    ["dragleave", "drop"].forEach(function (ev) {
      dropzone.addEventListener(ev, function () {
        dropzone.classList.remove("dragover");
      });
    });

    dropzone.addEventListener("drop", function (e) {
      var files = e.dataTransfer.files;
      if (files && files[0] && files[0].type.match(/^image\//)) {
        input.files = files;
        showPreview(files[0]);
      }
    });

    dropzone.addEventListener("click", function () {
      input.click();
    });

    if (clearBtn) {
      clearBtn.addEventListener("click", function (e) {
        e.stopPropagation();
        resetPreview();
      });
    }
  }

  function initSectionToggleHeaders() {
    document.querySelectorAll(".nc-section-header[data-bs-toggle='collapse']").forEach(function (header) {
      var target = document.querySelector(header.getAttribute("data-bs-target"));
      if (!target) return;
      target.addEventListener("shown.bs.collapse", function () {
        header.setAttribute("aria-expanded", "true");
      });
      target.addEventListener("hidden.bs.collapse", function () {
        header.setAttribute("aria-expanded", "false");
      });
    });
  }

  function initFeedbackButtons() {
    var group = document.getElementById("feedbackGroup");
    if (!group) return;

    var yesBtn = document.getElementById("btnHelpfulYes");
    var noBtn = document.getElementById("btnHelpfulNo");
    var toastEl = document.getElementById("feedbackToast");

    function showToast(message) {
      if (!toastEl || typeof bootstrap === "undefined") return;
      var body = toastEl.querySelector(".toast-body");
      if (body) body.textContent = message;
      var t = new bootstrap.Toast(toastEl);
      t.show();
    }

    if (yesBtn) {
      yesBtn.addEventListener("click", function () {
        yesBtn.classList.add("active-yes");
        yesBtn.classList.remove("btn-outline-secondary");
        if (noBtn) {
          noBtn.classList.remove("active-no");
        }
        showToast("Thanks — your feedback helps us improve.");
      });
    }

    if (noBtn) {
      noBtn.addEventListener("click", function () {
        noBtn.classList.add("active-no");
        if (yesBtn) {
          yesBtn.classList.remove("active-yes");
        }
        showToast("Thanks for letting us know. We'll work on better answers.");
      });
    }
  }

  function initSmoothAnchors() {
    var reduceMotion = window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    document.querySelectorAll('a[href^="#"]').forEach(function (a) {
      a.addEventListener("click", function (e) {
        var id = a.getAttribute("href");
        if (id.length > 1) {
          var el = document.querySelector(id);
          if (el) {
            e.preventDefault();
            el.scrollIntoView({ behavior: reduceMotion ? "auto" : "smooth", block: "start" });
          }
        }
      });
    });
  }

  function initJumpNavHighlight() {
    var pills = document.querySelectorAll(".nc-jump-pill[data-nc-jump]");
    if (!pills.length || typeof IntersectionObserver === "undefined") return;

    var sectionById = {};
    pills.forEach(function (pill) {
      var id = pill.getAttribute("data-nc-jump");
      if (!id) return;
      var el = document.getElementById(id);
      if (el) sectionById[id] = { el: el, pill: pill };
    });

    var ids = Object.keys(sectionById);
    if (!ids.length) return;

    function setActive(id) {
      ids.forEach(function (key) {
        sectionById[key].pill.classList.toggle("is-active", key === id);
      });
    }

    var observer = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry) {
          if (!entry.isIntersecting) return;
          setActive(entry.target.id);
        });
      },
      { rootMargin: "-12% 0px -50% 0px", threshold: [0, 0.1] }
    );

    ids.forEach(function (id) {
      observer.observe(sectionById[id].el);
    });
  }

  function initLogoutLinks() {
    document.querySelectorAll("[data-logout], #logoutBtn").forEach(function (btn) {
      btn.addEventListener("click", function () {
        localStorage.removeItem("loggedInUser");
        localStorage.removeItem("doubtData");
      });
    });
  }

  document.addEventListener("DOMContentLoaded", function () {
    initImagePreview();
    initSectionToggleHeaders();
    initFeedbackButtons();
    initSmoothAnchors();
    initJumpNavHighlight();
    initLogoutLinks();
  });
})();