FactoryGirl.define do
  factory :genre do
    name { FFaker::Music.genre }
  end
end
