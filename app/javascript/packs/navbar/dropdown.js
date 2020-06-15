document.addEventListener('DOMContentLoaded', () => {
  const dropDowns = Array.prototype.slice.call(document.querySelectorAll('.navbar-item.has-dropdown'), 0);
  if (dropDowns.length > 0) {
    dropDowns.forEach(addDropdownClickHandler);
  }
});

function addDropdownClickHandler(dropDown) {
  const trigger = dropDown.querySelector(".navbar-link");
  if (trigger) {
    trigger.addEventListener('click', () => {
      dropDown.classList.toggle("is-active");
    })
  }
}