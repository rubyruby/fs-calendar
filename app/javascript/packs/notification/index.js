document.addEventListener('DOMContentLoaded', () => {
  const notifications = Array.prototype.slice.call(document.querySelectorAll(".notification"), 0);
  if (notifications.length > 0) {
    notifications.forEach(addCloseClickListener);
  }
});

function addCloseClickListener(notification) {
  const closeBtn = notification.querySelector("button.delete");
  if (closeBtn) {
    closeBtn.addEventListener('click', () => {
      notification.remove();
    });
  }
}