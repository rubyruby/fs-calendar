class EventsByDateFilter

  def self.once_events(events, date)
    events.select { |event| event.once? && event.start_date == date }
  end

  def self.daily_events(events, date)
    events.select { |event| event.daily? && event.start_date <= date }
  end

  def self.weekly_events(events, date)
    events.select { |event| event.weekly? && event.start_date.wday == date.wday && event.start_date <= date }
  end

  def self.monthly_events(events, date)
    events.select { |event| event.monthly? && event.start_date.day == date.day && event.start_date <= date }
  end

  def self.yearly_events(events, date)
    events.select do |event|
      event.yearly? && event.start_date.day == date.day &&
        event.start_date.month == date.month && event.start_date <= date
    end
  end

end