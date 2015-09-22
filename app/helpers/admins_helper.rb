module AdminsHelper

	def convert_to_csv(bookings)
		attributes = %w{event_date guest_name host_name booking_ID host_account_number price_paid host_paid?}
		row = []
		bookings.each do |book|
			one_booking = []
			one_booking << book.date
			one_booking << "#{book.guest.first_name} #{book.guest.last_name}"
			one_booking << "#{book.experience.host.first_name} #{book.experience.host.last_name}"
			one_booking << book.id
			one_booking << book.experience.host.bank_number
			one_booking << book.experience.price
			one_booking << book.host_paid
			row << one_booking
		end
		CSV.generate(headers: true) do |csv|
			csv << attributes
			row.each do |one_row|
				csv << one_row 
			end
		end
	end
end
