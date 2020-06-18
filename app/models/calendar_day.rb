class CalendarDay

  attr_reader :date, :events

  def initialize(date, events)
    @date = date
    @events = events
  end

end