FactoryGirl.define do
	factory :guest do |f|
		f.username "Guest"
		f.email "hewrin@hotmail.com"
		f.password "123456789"
		f.password_confirmation "123456789"
		f.first_name "Bob"
		f.last_name "Tim"
		f.country "Malaysia"
	end
end