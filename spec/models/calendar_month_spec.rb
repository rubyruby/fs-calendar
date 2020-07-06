require 'rails_helper'

RSpec.describe CalendarMonth do

  describe '#month_date' do
    let(:calendar_month) { CalendarMonth.new(year, month) }

    context 'with valid year and month' do
      let(:year) { rand(2000..2020) }
      let(:month) { rand(1..12) }

      it 'returns date inside month' do
        month_as_date = Date.new(year, month)
        expect(calendar_month.month_date).to be_a(Date)
        expect(month_as_date.beginning_of_month..month_as_date.end_of_month).to include(calendar_month.month_date)
      end
    end

    context 'with invalid year or month' do
      let(:year) { rand(2000..2020) }
      let(:month) { rand(41..59) }

      it 'returns date inside current month' do
        month_as_date = Date.today
        expect(calendar_month.month_date).to be_a(Date)
        expect(month_as_date.beginning_of_month..month_as_date.end_of_month).to include(calendar_month.month_date)
      end
    end

  end

  describe '#days' do

    let(:user) { nil }
    let(:calendar_month) { CalendarMonth.new(2020, 7, user) }
    let(:start_date) { Date.new(2020, 6, 29) }
    let(:end_date) { Date.new(2020, 8, 2) }

    it 'returns array of calendar days inside month date + begin first week + end of last week' do
      days = calendar_month.days

      expect(days).to be_a(Array)
      expect(days.size).to eq(35)
      expect(days.first).to be_a(CalendarDay)
      expect(days.first.date).to eq(start_date)
      expect(days.last.date).to eq(end_date)
    end

    it 'returns calendar days with events by date' do
      expect(calendar_month.days.first.events).to be_a(Array)
    end

    context 'when user not defined' do
      let(:user) { nil }

      it 'returns calendar days with all events' do
        expect(EventsByPeriodQuery)
          .to receive(:call).with(Event.all, start_date: start_date, end_date: end_date).and_call_original
        expect(EventsByPeriodQuery)
          .not_to receive(:call).with(Event.by_user(user), start_date: start_date, end_date: end_date)
        calendar_month.days
      end
    end

    context 'when user defined' do
      let(:user) { create(:user) }

      it 'returns calendar days with events by user' do
        expect(EventsByPeriodQuery)
          .not_to receive(:call).with(Event.all, start_date: start_date, end_date: end_date)
        expect(EventsByPeriodQuery)
          .to receive(:call).with(Event.by_user(user), start_date: start_date, end_date: end_date).and_call_original
        calendar_month.days
      end
    end

  end

  describe '#previous' do
    let(:year) { rand(2000..2020) }
    let(:month) { rand(1..12) }
    let(:calendar_month) { CalendarMonth.new(year, month) }

    it 'returns previous calendar month' do
      previous_calendar_month = calendar_month.previous
      expect(previous_calendar_month).to be_a(CalendarMonth)

      previous_month = Date.new(year, month) - 1.month
      expect(previous_month.beginning_of_month..previous_month.end_of_month)
        .to include(previous_calendar_month.month_date)
    end
  end

  describe '#next' do
    let(:year) { rand(2000..2020) }
    let(:month) { rand(1..12) }
    let(:calendar_month) { CalendarMonth.new(year, month) }

    it 'returns next calendar month' do
      next_calendar_month = calendar_month.next
      expect(next_calendar_month).to be_a(CalendarMonth)

      next_month = Date.new(year, month) + 1.month
      expect(next_month.beginning_of_month..next_month.end_of_month).to include(next_calendar_month.month_date)
    end
  end

end