desc "One-off Post Sanitizing"
task :sanitize_post => :environment do
	Post.all.each do |post|
		post.update(body: Sanitize.fragment(post.body, :elements => ['br']))
	end
end

desc "Changing the Meal Times"
task :change_meal_time => :environment do
	Experience.all.each do |exp|
		if exp.meal == "Lunch"
			exp.update(time: Time.zone.local(2000, 01, 01, 11).in_time_zone, duration: 3)
		elsif exp.meal == "Dinner"
			exp.update(time: Time.zone.local(2000, 01, 01, 18, 30).in_time_zone, duration: 3.5)
		end
	end
end

desc "Changing the Booking Times"
task :change_booking_time => :environment do
	Booking.all.each do |booking|
		if booking.experience.meal == "Lunch"
			booking.update(start_time: booking.experience.time, end_time: booking.experience.time + 3.hours)
		elsif booking.experience.meal == "Dinner"
			booking.update(start_time: booking.experience.time, end_time: booking.experience.time + 3.5.hours)
		end
	end
end
