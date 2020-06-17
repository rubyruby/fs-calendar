document.addEventListener('DOMContentLoaded', () => {
  const dateSelectors = Array.prototype.slice.call(document.querySelectorAll('.js-calendar-date-selector'), 0);
  if (dateSelectors.length > 0) {
    dateSelectors.forEach(addSelectorChangeListeners);
  }
});

function addSelectorChangeListeners(dateSelector) {
  const monthSelect = dateSelector.querySelector('select[name="date[month]"]');
  const yearSelect = dateSelector.querySelector('select[name="date[year]"]');

  if (monthSelect && yearSelect) {
    monthSelect.addEventListener('change', (event) => {
      redirectToEvents(yearSelect.value, event.target.value);
    });
    yearSelect.addEventListener('change', (event) => {
      redirectToEvents(event.target.value, monthSelect.value);
    });
  }
}

function redirectToEvents(year, month) {
  window.location.replace(`/events?date=${year}-${month}-01`)
}