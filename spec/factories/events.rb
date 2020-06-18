FactoryBot.define do

  factory :event do
    user
    title { FFaker::Lorem.sentence }
    start_date { Date.today + rand(1..100).days }
    periodicity { Event.periodicity.values.sample }
  end

end