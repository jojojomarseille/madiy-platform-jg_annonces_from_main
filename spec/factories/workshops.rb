FactoryBot.define do
  factory :workshop do
    title { "MyString" }
    goal { "MyText" }
    description { "MyText" }
    more { nil }
    audience { "adult" }
    seats { 12 }
    main_picture { Rack::Test::UploadedFile.new("spec/fixtures/files/main_picture.txt") }
    association :category, factory: :workshop_category, strategy: :build

    trait :complete do
      association :workshop_duration, factory: :workshop_duration, strategy: :build
    end
  end
end
