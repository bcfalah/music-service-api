FactoryGirl.define do
  factory :album do
    name { FFaker::Music.album }
    #attachment { File.new("#{Rails.root}/spec/support/data/dog.jpg") }
  end
end
