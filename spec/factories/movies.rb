FactoryGirl.define do
	factory :movie do
		sequence(:title) { |i| "Title#{i}" }
		score { rand(1..99) }
		released true
		default true
		videoid '123'
		association :rt_datum
	end
end