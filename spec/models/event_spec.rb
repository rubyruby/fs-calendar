require 'rails_helper'

RSpec.describe Event, type: :model do

  describe 'validations' do
    subject { build(:event) }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:periodicity) }
    it { should validate_inclusion_of(:periodicity).in_array(Event.periodicity.values) }
  end

end