/**
 * Ask Doubt — image preview, drag-drop, validation, loading state
 */
(function () {
  "use strict";

  var form = document.getElementById("doubtForm");
  var fileInput = document.getElementById("questionImage");
  var dropzone = document.getElementById("dropzone");
  var preview = document.getElementById("imagePreview");
  var previewContainer = document.getElementById("previewContainer");
  var placeholder = document.getElementById("dropzonePlaceholder");
  var btnClearImage = document.getElementById("btnClearImage");
  var submitBtn = document.getElementById("btnSubmitDoubt");
  var formError = document.getElementById("formError");
  var errorText = document.getElementById("formErrorText");
  var subjectSelect = document.getElementById("subject");
  var chapterSelect = document.getElementById("chapter");
  var loadingOverlay = document.getElementById("loadingOverlay");

  /** Demo: chapters per subject (replace with server data in production) */
  var chaptersBySubject = {
    Mathematics: [
      "Real Numbers",
      "Polynomials",
      "Pair of Linear Equations in Two Variables",
      "Quadratic Equations",
      "Arithmetic Progressions",
    ],
    Science: [
      "Chemical Reactions and Equations",
      "Acids, Bases and Salts",
      "Metals and Non-metals",
      "Carbon and its Compounds",
      "Life Processes",
      "Light – Reflection and Refraction",
    ],
    "Social Science": [
      "The Rise of Nationalism in Europe",
      "Nationalism in India",
      "Resources and Development",
      "Forest and Wildlife Resources",
    ],
    English: ["First Flight", "Footprints without Feet", "Grammar"],
    Hindi: ["क्षितिज", "स्पर्श", "व्याकरण"],
  };

  function showError(message) {
    if (!formError || !errorText) return;
    errorText.textContent = message;
    formError.classList.remove("d-none");
    formError.scrollIntoView({ behavior: "smooth", block: "nearest" });
  }

  function hideError() {
    if (formError) formError.classList.add("d-none");
  }

  function setDropzoneInvalid(invalid) {
    if (!dropzone) return;
    dropzone.classList.toggle("is-invalid", invalid);
  }

  function showPreview(file) {
    if (!file || !file.type.match(/^image\//)) return;
    var reader = new FileReader();
    reader.onload = function (e) {
      preview.src = e.target.result;
      preview.classList.remove("d-none");
      if (previewContainer) previewContainer.classList.remove("d-none");
      if (placeholder) placeholder.classList.add("d-none");
      if (btnClearImage) btnClearImage.classList.remove("d-none");
      setDropzoneInvalid(false);
      hideError();
    };
    reader.readAsDataURL(file);
  }

  function clearImage() {
    if (fileInput) fileInput.value = "";
    if (preview) {
      preview.src = "";
      preview.classList.add("d-none");
    }
    if (previewContainer) previewContainer.classList.add("d-none");
    if (placeholder) placeholder.classList.remove("d-none");
    if (btnClearImage) btnClearImage.classList.add("d-none");
    setDropzoneInvalid(false);
  }

  function populateChapters() {
    if (!subjectSelect || !chapterSelect) return;
    var sub = subjectSelect.value;
    chapterSelect.innerHTML = "";

    var list = chaptersBySubject[sub];
    if (!sub || !list) {
      var opt = document.createElement("option");
      opt.value = "";
      opt.textContent = sub ? "No chapters listed" : "Choose a subject first";
      chapterSelect.appendChild(opt);
      chapterSelect.disabled = true;
      return;
    }

    chapterSelect.disabled = false;
    var def = document.createElement("option");
    def.value = "";
    def.textContent = "Select chapter";
    def.disabled = true;
    def.selected = true;
    chapterSelect.appendChild(def);

    list.forEach(function (title) {
      var o = document.createElement("option");
      o.value = title;
      o.textContent = title;
      chapterSelect.appendChild(o);
    });
  }

  function validate() {
    hideError();
    setDropzoneInvalid(false);

    var classEl = document.getElementById("classGrade");
    var lang = document.getElementById("language");
    var text = document.getElementById("questionText");
    var hasFile = fileInput && fileInput.files && fileInput.files.length > 0;
    var textVal = text && text.value ? text.value.trim() : "";

    if (!classEl || !classEl.value) {
      showError("Please select your class.");
      return false;
    }
    if (!subjectSelect || !subjectSelect.value) {
      showError("Please select a subject.");
      return false;
    }
    if (!chapterSelect || !chapterSelect.value) {
      showError("Please select a chapter.");
      return false;
    }
    if (!lang || !lang.value) {
      showError("Please choose a response language.");
      return false;
    }
    if (!textVal && !hasFile) {
      showError("Type your question in the box or upload a clear image of the question (at least one is required).");
      setDropzoneInvalid(true);
      if (text) text.focus();
      return false;
    }

    return true;
  }

  function showLoading() {
    if (loadingOverlay) {
      loadingOverlay.classList.add("show");
      loadingOverlay.setAttribute("aria-hidden", "false");
      document.body.style.overflow = "hidden";
    }
    if (submitBtn) {
      submitBtn.disabled = true;
    }
  }

  function hideLoading() {
    if (loadingOverlay) {
      loadingOverlay.classList.remove("show");
      loadingOverlay.setAttribute("aria-hidden", "true");
      document.body.style.overflow = "";
    }
    if (submitBtn) {
      submitBtn.disabled = false;
    }
  }

  function initDropzone() {
    if (!dropzone || !fileInput) return;

    fileInput.addEventListener("change", function () {
      if (fileInput.files && fileInput.files[0]) {
        showPreview(fileInput.files[0]);
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
        dropzone.classList.add("ad-dropzone--drag");
      });
    });

    ["dragleave", "drop"].forEach(function (ev) {
      dropzone.addEventListener(ev, function () {
        dropzone.classList.remove("ad-dropzone--drag");
      });
    });

    dropzone.addEventListener("drop", function (e) {
      var files = e.dataTransfer.files;
      if (files && files[0] && files[0].type.match(/^image\//)) {
        try {
          var dt = new DataTransfer();
          dt.items.add(files[0]);
          fileInput.files = dt.files;
        } catch (err) {
          showPreview(files[0]);
          return;
        }
        showPreview(files[0]);
      } else if (files && files[0]) {
        showError("Please drop an image file (PNG or JPG).");
      }
    });

    dropzone.addEventListener("click", function (e) {
      if (e.target.closest("#btnClearImage")) return;
      fileInput.click();
    });
  }

  if (subjectSelect) {
    subjectSelect.addEventListener("change", populateChapters);
    populateChapters();
  }

  if (btnClearImage) {
    btnClearImage.addEventListener("click", function (e) {
      e.preventDefault();
      e.stopPropagation();
      clearImage();
    });
  }

  if (form) {
    form.addEventListener("submit", function (e) {
      if (!validate()) {
        e.preventDefault();
        return;
      }
      e.preventDefault();
      showLoading();

      // Simulate AI pipeline (OCR + Gemini); replace with fetch() to your servlet
      window.setTimeout(function () {
        form.submit();
      }, 2200);
    });
  }

  // If page unloads during navigation, hide overlay
  window.addEventListener("pageshow", hideLoading);

  document.addEventListener("DOMContentLoaded", function () {
    initDropzone();
  });
})();
