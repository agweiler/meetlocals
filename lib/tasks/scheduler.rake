desc "One-off Post Sanitizing"
task :sanitize_post => :environment do
	Post.all.each do |post|
		post.update(body: Sanitize.fragment(post.body, :elements => ['br']))
	end
end

desc "This task is called by the Heroku scheduler add-on"
task :reminder_one_day_before => :environment do
	confirmed_booking = Booking.where(status: "confirmed")
	bookings_a_day_away = confirmed_booking.where("date = ?" ,Date.today + 1.day).pluck(:id,:experience_id)
	bookings_a_day_away.each do |booking_id,exp_id|
		host_id = Experience.find(exp_id).host_id
		Hostmailer.event_reminder(booking_id,host_id,1).deliver_now
	end	
end

task :reminder_three_day_before => :environment do
	confirmed_booking = Booking.where(status: "confirmed")
	bookings_3_days_away = confirmed_booking.where("date = ?" ,Date.today + 3.day).pluck(:id,:experience_id)
	bookings_3_days_away.each do |booking_id,exp_id|
		host_id = Experience.find(exp_id).host_id
		Hostmailer.event_reminder(booking_id,host_id,3).deliver_now
	end	
end

task :reminder_payment_four_day_before => :environment do
	confirmed_booking = Booking.where(status: "confirmed")
	bookings_3_days_away = confirmed_booking.where("date = ?" ,Date.today + 4.day).pluck(:id,:experience_id)
	bookings_3_days_away.each do |booking_id,exp_id|
		host_id = Experience.find(exp_id).host_id
		Adminmailer.payment_reminder(booking_id,host_id,3).deliver_now
	end	
end

task :completed_experience => :environment do
	confirmed_booking = Booking.where(status: "confirmed")
	confirmed_booking.each do |booking|
		if booking.check_finished? == true
			experience = booking.experience
			host = experience.host
			hosts_revenue = ((experience.price * booking.group_size * 1.019 + 2.60).round(2)) * Admin.first.commision_percentage/100.round(2)
			new_revenue = host.revenue + hosts_revenue
			host.update(revenue: new_revenue)
			Guestmailer.experience_completed(booking.id,booking.guest.id).deliver_now
			booking.update(status: "completed")
		end
	end	
end