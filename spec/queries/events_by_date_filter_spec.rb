require 'rails_helper'

RSpec.describe EventsByDateFilter do

  let(:date) { Date.today + rand(-100..100).days }
  let!(:all_events) do
    once_events +
      once_events_in_other_date +
      daily_events +
      daily_events_in_future +
      weekly_events +
      weekly_events_in_another_weekday +
      weekly_events_in_future +
      monthly_events +
      monthly_events_in_another_day +
      monthly_events_in_future +
      yearly_events +
      yearly_events_in_another_day +
      yearly_events_in_another_month +
      yearly_events_in_future
  end

  let(:once_events) { 3.times.map { create(:event, :once, start_date: date) } }
  let(:once_events_in_other_date) { 3.times.map { create(:event, :once, start_date: date + rand(1..10).days) } }

  let(:daily_events) { 3.times.map { create(:event, :daily, start_date: date - rand(0..1000).days) } }
  let(:daily_events_in_future) { 3.times.map { create(:event, :daily, start_date: date + rand(1..1000).days ) } }

  let(:weekly_events) { 3.times.map { create(:event, :weekly, start_date: date - rand(0..100).weeks) } }
  let(:weekly_events_in_another_weekday) do
    3.times.map { create(:event, :weekly, start_date: date - rand(0..100).weeks - rand(1..6).days) }
  end
  let(:weekly_events_in_future) { 3.times.map { create(:event, :weekly, start_date: date + rand(1..100).weeks) } }

  let(:monthly_events) { 3.times.map { create(:event, :monthly, start_date: date - rand(0..20).months) } }
  let(:monthly_events_in_another_day) do
    3.times.map { create(:event, :monthly, start_date: date - rand(0..20).months - rand(1..15).days) }
  end
  let(:monthly_events_in_future) { 3.times.map { create(:event, :monthly, start_date: date + rand(1..20).months) } }

  let(:yearly_events) { 3.times.map { create(:event, :yearly, start_date: date - rand(0..30).years) } }
  let(:yearly_events_in_another_month) do
    3.times.map { create(:event, :yearly, start_date: date - rand(0..30).years - rand(1..11).month) }
  end
  let(:yearly_events_in_another_day) do
    3.times.map { create(:event, :yearly, start_date: date - rand(0..30).years - rand(1..11).days) }
  end
  let(:yearly_events_in_future) { 3.times.map { create(:event, :yearly, start_date: date + rand(1..30).years) } }

  specify '.once_events returns once events in date' do
    expect(EventsByDateFilter.once_events(all_events, date)).to contain_exactly(*once_events)
  end

  specify '.daily_events returns daily events with start date less or equal to date' do
    expect(EventsByDateFilter.daily_events(all_events, date)).to contain_exactly(*daily_events)
  end

  specify '.weekly_events returns weekly events in same weekday with start date less or equal to date' do
    expect(EventsByDateFilter.weekly_events(all_events, date)).to contain_exactly(*weekly_events)
  end

  specify '.monthly_events returns monthly events in same day with start date less or equal to date' do
    expect(EventsByDateFilter.monthly_events(all_events, date)).to contain_exactly(*monthly_events)
  end

  specify '.yearly_events returns yearly events in same day and month with start date less or equal to date' do
    expect(EventsByDateFilter.yearly_events(all_events, date)).to contain_exactly(*yearly_events)
  end

end