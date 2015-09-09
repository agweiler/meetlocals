FactoryGirl.define do
	factory :admin do |f|
		f.email "hewrin@hotmail.com"
		f.password "123456789"
		f.password_confirmation "123456789"
		f.commision_percentage 10
	end
end