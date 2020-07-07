require 'rails_helper'

RSpec.describe 'Events', type: :feature, js: true do

  let(:user) { create(:user) }
  before(:each) { login_as(user) }

  describe 'display days' do

    it 'displays current month days' do
      today = Date.today

      visit events_path

      expect(page).to have_css("#day_#{today.strftime('%Y_%m_%d')}")
      expect(page).to have_css("#day_#{today.beginning_of_month.strftime('%Y_%m_%d')}")
      expect(page).to have_css("#day_#{today.end_of_month.strftime('%Y_%m_%d')}")
    end

    it 'displays month days by year and month' do
      date = Date.today + rand(-10000..10000).days

      visit my_month_events_path(year: date.year, month: date.month)

      expect(page).to have_css("#day_#{date.strftime('%Y_%m_%d')}")
      expect(page).to have_css("#day_#{date.beginning_of_month.strftime('%Y_%m_%d')}")
      expect(page).to have_css("#day_#{date.end_of_month.strftime('%Y_%m_%d')}")
    end

  end

  describe 'display events' do

    let(:start_date) { (Date.today + rand(-10000..10000).days).beginning_of_month }
    let(:end_date) { start_date.end_of_month }

    let!(:once_events_inside_period) do
      3.times.map { create(:event, :once, start_date: (start_date..end_date).to_a.sample) }
    end
    let!(:once_events_outside_period) do
      3.times.map { create(:event, :once, start_date: start_date - rand(50..100).days) } +
        3.times.map { create(:event, :once, start_date: end_date + rand(50..100).days) }
    end

    let!(:daily_events_inside_period) do
      3.times.map { create(:event, :daily, start_date: end_date - rand(0..1000).days) }
    end
    let!(:daily_events_outside_period) do
      3.times.map { create(:event, :daily, start_date: end_date + rand(1..1000).days) }
    end

    let!(:weekly_events_inside_period) do
      3.times.map { create(:event, :weekly, start_date: end_date - rand(0..1000).days) }
    end
    let!(:weekly_events_outside_period) do
      3.times.map { create(:event, :weekly, start_date: end_date + rand(1..1000).days) }
    end

    let!(:monthly_events_inside_period) do
      3.times.map { create(:event, :monthly, start_date: end_date - rand(0..1000).days) }
    end
    let!(:monthly_events_outside_period) do
      3.times.map { create(:event, :monthly, start_date: end_date + rand(1..1000).days) }
    end

    let!(:yearly_events_inside_period) do
      3.times.map { create(:event, :yearly, start_date: (start_date..end_date).to_a.sample - rand(0..10).years) }
    end
    let!(:yearly_events_outside_period) do
      3.times.map { create(:event, :yearly, start_date: (start_date..end_date).to_a.sample + rand(1..5).years) } +
        3.times.map { create(:event, :yearly, start_date: start_date - rand(50..80).days) } +
        3.times.map { create(:event, :yearly, start_date: end_date + rand(50..80).days) }
    end

    let!(:user_once_events) do
      3.times.map { create(:event, :once, user: user, start_date: (start_date..end_date).to_a.sample) }
    end
    let!(:user_daily_events) do
      3.times.map { create(:event, :daily, user: user, start_date: end_date - rand(0..1000).days) }
    end
    let!(:user_weekly_events) do
      3.times.map { create(:event, :weekly, user: user, start_date: end_date - rand(0..1000).days) }
    end
    let!(:user_monthly_events) do
      3.times.map { create(:event, :monthly, user: user, start_date: end_date - rand(0..1000).days) }
    end
    let!(:user_yearly_events) do
      3.times.map do
        create(:event, :yearly, user: user, start_date: (start_date..end_date).to_a.sample - rand(0..10).years)
      end
    end

    it "displays user's events only inside month" do
      visit my_month_events_path(year: start_date.year, month: start_date.month)

      user_once_events.each { |e| expect(page).to have_content(e.title) }
      user_daily_events.each { |e| expect(page).to have_content(e.title) }
      user_weekly_events.each { |e| expect(page).to have_content(e.title) }
      user_monthly_events.each { |e| expect(page).to have_content(e.title) }
      user_yearly_events.each { |e| expect(page).to have_content(e.title) }

      once_events_inside_period.each { |e| expect(page).to have_no_content(e.title) }
      once_events_outside_period.each { |e| expect(page).to have_no_content(e.title) }
      daily_events_inside_period.each { |e| expect(page).to have_no_content(e.title) }
      daily_events_outside_period.each { |e| expect(page).to have_no_content(e.title) }
      monthly_events_inside_period.each { |e| expect(page).to have_no_content(e.title) }
      monthly_events_outside_period.each { |e| expect(page).to have_no_content(e.title) }
      yearly_events_inside_period.each { |e| expect(page).to have_no_content(e.title) }
      yearly_events_outside_period.each { |e| expect(page).to have_no_content(e.title) }
    end

    it 'displays all events in month' do
      visit all_month_events_path(year: start_date.year, month: start_date.month)

      user_once_events.each { |e| expect(page).to have_content(e.title) }
      user_daily_events.each { |e| expect(page).to have_content(e.title) }
      user_weekly_events.each { |e| expect(page).to have_content(e.title) }
      user_monthly_events.each { |e| expect(page).to have_content(e.title) }
      user_yearly_events.each { |e| expect(page).to have_content(e.title) }

      once_events_inside_period.each { |e| expect(page).to have_content(e.title) }
      daily_events_inside_period.each { |e| expect(page).to have_content(e.title) }
      monthly_events_inside_period.each { |e| expect(page).to have_content(e.title) }
      yearly_events_inside_period.each { |e| expect(page).to have_content(e.title) }

      once_events_outside_period.each { |e| expect(page).to have_no_content(e.title) }
      daily_events_outside_period.each { |e| expect(page).to have_no_content(e.title) }
      monthly_events_outside_period.each { |e| expect(page).to have_no_content(e.title) }
      yearly_events_outside_period.each { |e| expect(page).to have_no_content(e.title) }
    end

    it 'displays non-user event' do
      event = once_events_inside_period.first

      visit all_month_events_path(year: start_date.year, month: start_date.month)
      click_link event.title

      expect(page).to have_css('.title', text: event.title)
      expect(current_path).to eq(event_path(event))
    end

  end

  describe 'create event' do

    context 'with valid attributes' do
      let(:event_attributes) { attributes_for(:event) }

      it 'creates event' do
        visit events_path
        click_link I18n.t('events.toolbar.add')

        expect {
          fill_in 'event_title', with: event_attributes[:title]
          select event_attributes[:start_date].year, from: 'event[start_date(1i)]'
          select I18n.t('date.month_names')[event_attributes[:start_date].month], from: 'event[start_date(2i)]'
          select event_attributes[:start_date].day, from: 'event[start_date(3i)]'
          select event_attributes[:periodicity].text, from: 'event_periodicity'
          click_button I18n.t('events.form.save')
          expect(page).to have_content(I18n.t('events.create.notice'))
        }.to change { Event.count }.by(1)
      end
    end

    context 'with invalid attributes' do
      let(:event_attributes) { attributes_for(:event, :invalid) }

      it 'does not create event' do
        visit events_path
        click_link I18n.t('events.toolbar.add')

        expect {
          fill_in 'event_title', with: event_attributes[:title]
          select event_attributes[:start_date].year, from: 'event[start_date(1i)]'
          select I18n.t('date.month_names')[event_attributes[:start_date].month], from: 'event[start_date(2i)]'
          select event_attributes[:start_date].day, from: 'event[start_date(3i)]'
          select event_attributes[:periodicity].text, from: 'event_periodicity'
          click_button I18n.t('events.form.save')
          expect(page).to have_css('#new_event .field .help.is-danger')
        }.not_to(change { Event.count })
      end
    end

  end

  describe 'update event' do

    let(:event) { create(:event, :once, user: user) }

    context 'with valid attributes' do
      it 'updates event' do
        visit my_month_events_path(year: event.start_date.year, month: event.start_date.month)
        click_link event.title

        new_title = attributes_for(:event)[:title]
        fill_in 'event_title', with: new_title
        click_button I18n.t('events.form.save')

        expect(page).to have_content(I18n.t('events.update.notice'))
        event.reload
        expect(event.title).to eq(new_title)
      end
    end

    context 'with invalid attributes' do
      it 'does not update event' do
        visit my_month_events_path(year: event.start_date.year, month: event.start_date.month)
        click_link event.title

        new_title = ''
        previous_title = event.title

        fill_in 'event_title', with: new_title
        click_button I18n.t('events.form.save')

        expect(page).to have_css('.edit_event .field .help.is-danger')
        event.reload
        expect(event.title).to eq(previous_title)
      end
    end

  end

  describe 'remove event' do

    let(:event) { create(:event, :once, user: user) }

    it 'removes event' do
      visit my_month_events_path(year: event.start_date.year, month: event.start_date.month)
      click_link event.title

      expect {
        accept_confirm do
          click_link I18n.t('events.form.remove')
        end
        expect(page).to have_content(I18n.t('events.destroy.notice'))
      }.to change { Event.count }.by(-1)
      expect(Event.where(id: event.id).exists?).to eq(false)
    end

  end

end