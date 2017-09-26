FactoryGirl.define do
  factory :album do
    name { FFaker::Music.album }
    artwork_url { "https://images.fineartamerica.com/images-medium-large-5/the-beatles-abbey-road-artwork-sheraz-a.jpg" }
  end
end
