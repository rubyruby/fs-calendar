class MonthEventsQuery

  def self.call(relation = Event.all, start_date:, end_date:)
    relation
      .with_periodicity(:monthly)
      .or(relation.with_periodicity(:weekly))
      .or(relation.with_periodicity(:daily))
      .or(relation.with_periodicity(:once).where(start_date: (start_date..end_date)))
      .or(relation.with_periodicity(:yearly)
            .where("date_part('doy', events.start_date) BETWEEN ? AND ?", start_date.yday, end_date.yday))
  end

end