class EventsByPeriodQuery

  def self.call(relation = Event.all, start_date:, end_date:)
    events = relation.where('events.start_date <= ?', end_date)
    events
      .with_periodicity(:monthly)
      .or(events.with_periodicity(:weekly))
      .or(events.with_periodicity(:daily))
      .or(events.with_periodicity(:once).where(start_date: (start_date..end_date)))
      .or(events.with_periodicity(:yearly)
            .where("to_char(events.start_date, 'MMDD') IN (?)", (start_date..end_date).map { |d| d.strftime('%m%d') }))
  end

end