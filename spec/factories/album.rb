FactoryGirl.define do
  factory :album do
    name { FFaker::Music.album }
    artwork { File.new("#{Rails.root}/spec/support/data/abbey_road.jpg") }
  end
end
