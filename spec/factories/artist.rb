FactoryGirl.define do
  factory :artist do
    name { FFaker::Music.artist }
    biography { FFaker::Lorem.paragraphs(6).join(" ") }
  end
end
