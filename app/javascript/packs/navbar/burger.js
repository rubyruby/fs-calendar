document.addEventListener('DOMContentLoaded', () => {
  const burgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);
  if (burgers.length > 0) {
    burgers.forEach(addBurgerClickListener);
  }
});

function addBurgerClickListener(burger) {
  const menu = document.getElementById(burger.dataset.target);
  if (menu) {
    burger.addEventListener('click', () => {
      burger.classList.toggle('is-active');
      menu.classList.toggle('is-active');
    });
  }
}