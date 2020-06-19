class CalendarMonth

  attr_reader :month_date

  def initialize(year, month)
    @month_date = build_month_date(year, month)
  end

  def days
    (start_date..end_date).map do |date|
      events_in_date = once_events(date) +
                       daily_events(date) +
                       weekly_events(date) +
                       monthly_events(date) +
                       yearly_events(date)
      CalendarDay.new(date, events_in_date)
    end
  end

  def year
    month_date.year
  end

  def month
    month_date.month
  end

  def previous
    previous_date = month_date - 1.month
    CalendarMonth.new(previous_date.year, previous_date.month)
  end

  def next
    next_date = month_date + 1.month
    CalendarMonth.new(next_date.year, next_date.month)
  end

  private

  def once_events(date)
    events.select { |event| event.once? && event.start_date == date }
  end

  def daily_events(date)
    events.select { |event| event.daily? && event.start_date <= date }
  end

  def weekly_events(date)
    events.select { |event| event.weekly? && event.start_date.wday == date.wday && event.start_date <= date }
  end

  def monthly_events(date)
    events.select { |event| event.monthly? && event.start_date.day == date.day && event.start_date <= date }
  end

  def yearly_events(date)
    events.select do |event|
      event.yearly? && event.start_date.day == date.day &&
        event.start_date.month == date.month && event.start_date <= date
    end
  end

  def events
    @events ||= MonthEventsQuery.call(start_date: start_date, end_date: end_date)
  end

  def start_date
    month_date.beginning_of_month.beginning_of_week
  end

  def end_date
    month_date.end_of_month.end_of_week
  end

  def build_month_date(year, month)
    Date.new(year.to_i, month.to_i)
  rescue ArgumentError
    Date.today
  end

end
