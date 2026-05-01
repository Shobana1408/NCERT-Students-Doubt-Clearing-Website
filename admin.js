/**
 * Admin shell: mobile sidebar toggle, optional filter form helpers
 */
(function () {
  "use strict";

  function initSidebar() {
    var toggle = document.getElementById("admSidebarToggle");
    var sidebar = document.getElementById("admSidebar");
    var backdrop = document.getElementById("admSidebarBackdrop");

    function openMenu() {
      if (sidebar) sidebar.classList.add("show");
      if (backdrop) backdrop.classList.add("show");
      document.body.style.overflow = "hidden";
    }

    function closeMenu() {
      if (sidebar) sidebar.classList.remove("show");
      if (backdrop) backdrop.classList.remove("show");
      document.body.style.overflow = "";
    }

    if (toggle) {
      toggle.addEventListener("click", function () {
        if (sidebar && sidebar.classList.contains("show")) closeMenu();
        else openMenu();
      });
    }

    if (backdrop) {
      backdrop.addEventListener("click", closeMenu);
    }

    document.querySelectorAll("#admSidebar a.nav-link").forEach(function (link) {
      link.addEventListener("click", function () {
        if (window.innerWidth < 992) closeMenu();
      });
    });
  }

  document.addEventListener("DOMContentLoaded", initSidebar);
})();
