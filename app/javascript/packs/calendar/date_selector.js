document.addEventListener('DOMContentLoaded', () => {
  const dateSelectors = Array.prototype.slice.call(document.querySelectorAll('.js-calendar-date-selector'), 0);
  if (dateSelectors.length > 0) {
    dateSelectors.forEach(addSelectorChangeListeners);
  }
});

function addSelectorChangeListeners(dateSelector) {
  const monthSelect = dateSelector.querySelector('select[name="date[month]"]');
  const yearSelect = dateSelector.querySelector('select[name="date[year]"]');
  const userEventsOnly = dateSelector.hasAttribute("data-user-events-only");

  if (monthSelect && yearSelect) {
    monthSelect.addEventListener('change', (event) => {
      redirectToEvents(yearSelect.value, event.target.value, userEventsOnly);
    });
    yearSelect.addEventListener('change', (event) => {
      redirectToEvents(event.target.value, monthSelect.value, userEventsOnly);
    });
  }
}

function redirectToEvents(year, month, userEventsOnly) {
  let path = null;
  if (userEventsOnly) {
    path = `/events/${year}/${month}`;
  } else {
    path = `/events/${year}/${month}/all`;
  }
  window.location.replace(path);
}
