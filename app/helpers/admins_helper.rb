module AdminsHelper

	def convert_to_csv(bookings)
		attributes = %w{event_date booking_ID guest_name guest_id num_of_adult_for_event num_of_children_for_event host_name host_id host_address host_zip_and_town host_email host_phone host_account_number price_paid host_paid?}
		row = []
		bookings.each do |book|
			one_booking = []
			one_booking << book.date
			one_booking << book.id
			one_booking << "#{book.guest.first_name} #{book.guest.last_name}"
			one_booking << book.guest.id
			one_booking << book.no_of_adults
			one_booking << book.no_of_children
			one_booking << "#{book.experience.host.first_name} #{book.experience.host.last_name}"
			one_booking << book.experience.host.id
			one_booking << book.experience.host.street_address
			one_booking << book.experience.host.suburb
			one_booking << book.experience.host.email
			one_booking << book.experience.host.phone
			one_booking << book.experience.host.bank_number
			one_booking << book.experience.price
			one_booking << book.host_paid
			row << one_booking
		end
		CSV.generate(headers: true, :col_sep => "\t") do |csv|
			csv << attributes
			row.each do |one_row|
				csv << one_row 
			end
		end
	end
end
