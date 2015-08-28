FactoryGirl.define do
	factory :host do |f|
		f.username "Host"
		f.email "hewrin@hotmail.com"
		f.password "123456789"
		f.password_confirmation "123456789"
		f.first_name "Bob"
		f.last_name "Tim"
		f.country "Malaysia"
		f.state "Zealand"
		f.suburb "Aaalborg"
		f.title "Mr"
		f.approved true
		f.max_group_size 10
		f.phone "012-2322343"
	end
end