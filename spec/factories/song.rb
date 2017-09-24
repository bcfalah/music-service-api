FactoryGirl.define do
  factory :song do
    name { FFaker::Music.song }
    duration { rand(1..1000) }
    genre_name { FFaker::Music.genre }
    #attachment { File.new("#{Rails.root}/spec/support/data/dog.jpg") }
  end
end
