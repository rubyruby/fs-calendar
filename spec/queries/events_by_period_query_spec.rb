require 'rails_helper'

RSpec.describe EventsByPeriodQuery do

  describe '.call' do
    let(:result) { EventsByPeriodQuery.call(start_date: start_date, end_date: end_date) }

    let(:start_date) { Date.today + rand(-100..100).days }
    let(:end_date) { start_date + rand(1..30).days }

    let!(:once_events_inside_period) do
      3.times.map { create(:event, :once, start_date: (start_date..end_date).to_a.sample) }
    end
    let!(:once_events_outside_period) do
      3.times.map { create(:event, :once, start_date: start_date - rand(1..100).days) } +
        3.times.map { create(:event, :once, start_date: end_date + rand(1..100).days) }
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

    it 'returns relation' do
      expect(result).to be_a(ActiveRecord::Relation)
    end

    it 'returns once events inside period' do
      expect(result).to include(*once_events_inside_period)
    end

    it 'does not return once events outside period' do
      expect(result).not_to include(*once_events_outside_period)
    end

    it 'returns daily events inside period' do
      expect(result).to include(*daily_events_inside_period)
    end

    it 'does not return daily events outside period' do
      expect(result).not_to include(*daily_events_outside_period)
    end

    it 'returns weekly events inside period' do
      expect(result).to include(*weekly_events_inside_period)
    end

    it 'does not return weekly events outside period' do
      expect(result).not_to include(*weekly_events_outside_period)
    end

    it 'returns monthly events inside period' do
      expect(result).to include(*monthly_events_inside_period)
    end

    it 'does not return monthly events outside period' do
      expect(result).not_to include(*monthly_events_outside_period)
    end

    it 'returns yearly events inside period' do
      expect(result).to include(*yearly_events_inside_period)
    end

    it 'does not return yearly events outside period' do
      expect(result).not_to include(*yearly_events_outside_period)
    end

    context 'with by_user relation' do
      let(:user) { create(:user) }
      let(:result) { EventsByPeriodQuery.call(Event.by_user(user), start_date: start_date, end_date: end_date) }

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

      it "returns user's once events inside period" do
        expect(result).to include(*user_once_events)
      end

      it "returns user's daily events inside period" do
        expect(result).to include(*user_daily_events)
      end

      it "returns user's weekly events inside period" do
        expect(result).to include(*user_weekly_events)
      end

      it "returns user's monthly events inside period" do
        expect(result).to include(*user_monthly_events)
      end

      it "returns user's yearly events inside period" do
        expect(result).to include(*user_yearly_events)
      end

      it 'does not returns events of other users' do
        expect(result).not_to include(*once_events_inside_period)
        expect(result).not_to include(*once_events_outside_period)
        expect(result).not_to include(*daily_events_inside_period)
        expect(result).not_to include(*daily_events_outside_period)
        expect(result).not_to include(*weekly_events_inside_period)
        expect(result).not_to include(*weekly_events_outside_period)
        expect(result).not_to include(*monthly_events_inside_period)
        expect(result).not_to include(*monthly_events_outside_period)
        expect(result).not_to include(*yearly_events_inside_period)
        expect(result).not_to include(*yearly_events_outside_period)
      end
    end

  end

end
