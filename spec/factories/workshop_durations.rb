FactoryBot.define do
  factory :workshop_duration do
    hours { 1 }
    minutes { 30 }
    association :workshop, factory: :workshop, strategy: :build
  end
end
