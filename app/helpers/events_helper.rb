module EventsHelper

  def previous_month_events_path(calendar_month)
    previous_calendar_month = calendar_month.previous
    if calendar_month.user
      my_month_events_path(year: previous_calendar_month.year, month: previous_calendar_month.month)
    else
      all_month_events_path(year: previous_calendar_month.year, month: previous_calendar_month.month)
    end
  end

  def next_month_events_path(calendar_month)
    next_calendar_month = calendar_month.next
    if calendar_month.user
      my_month_events_path(year: next_calendar_month.year, month: next_calendar_month.month)
    else
      all_month_events_path(year: next_calendar_month.year, month: next_calendar_month.month)
    end
  end

end