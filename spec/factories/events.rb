FactoryBot.define do

  factory :event do

    user
    title { FFaker::Lorem.sentence }
    start_date { Date.today + rand(-100..100).days }
    periodicity { Event.periodicity.values.sample }

    Event.periodicity.values.each do |period|
      trait period do
        periodicity { period }
      end
    end

    trait :invalid do
      title { nil }
    end

  end

end
