FactoryGirl.define do
  factory :artist do
    sequence(:name) {|n| FFaker::Music.artist + " (#{n})"}
    biography { FFaker::Lorem.paragraphs(6).join(" ") }
  end
end
