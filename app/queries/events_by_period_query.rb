class EventsByPeriodQuery

  def self.call(relation = Event.all, start_date:, end_date:)
    events = relation.where('events.start_date <= ?', end_date)
    events
      .with_periodicity(:monthly)
      .or(events.with_periodicity(:weekly))
      .or(events.with_periodicity(:daily))
      .or(events.with_periodicity(:once).where(start_date: (start_date..end_date)))
      .or(events.with_periodicity(:yearly)
            .where("date_part('doy', events.start_date) BETWEEN ? AND ?", start_date.yday, end_date.yday))
  end

end