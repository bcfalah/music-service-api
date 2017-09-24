FactoryGirl.define do
  factory :playlist do
    name { FFaker::Music.genre + ' ' + rand(1..1000).to_s }
  end
end
