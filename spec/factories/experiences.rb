FactoryGirl.define do
	factory :experience do |f|
		f.title "Eat"
		f.description "Eat a lot"
		f.cuisine "food"
		f.price 450.00
		f.max_group_size 10
		f.meal "lunch"
	# trait :second_experience do |f|
		
	end

end

