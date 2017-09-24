FactoryGirl.define do
  factory :song do
    name { FFaker::Music.song }
    duration { rand(1..1000) }
    genre_name { FFaker::Music.genre }    
  end
end
