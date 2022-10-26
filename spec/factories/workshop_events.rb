FactoryBot.define do
  factory :workshop_event do
    start_time { 1.week.from_now.at_beginning_of_week + 15.hours }
    association :workshop, factory: :workshop, strategy: :build
  end
end
