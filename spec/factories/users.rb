FactoryBot.define do

  factory :user do
    sequence(:email) { |i| "#{i}#{FFaker::Internet.free_email}" }
    password { FFaker::Internet.password }
    password_confirmation { password }
  end

end