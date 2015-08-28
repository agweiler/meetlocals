class Adminmailer < ApplicationMailer
	def host_created(host_id, bank_number,bank_name,reg_number)
		@host = Host.find host_id
		@admin = Admin.find 1
		@bank_number = bank_number
		@bank_name = bank_name
		@registration_number = reg_number
		mail(to: @admin.email, subject: "A new host has been created!")
	end

	def experience_completed(host_id, guest_id)
		@host = Host.find host_id
		@guest = Guest.find guest_id
		@admin = Admin.first
		mail(to: @admin.email, subject: "A host has completed an experience")
	end

	def host_cancel(guest_id,host_id,booking_id)
		@guest = Guest.find guest_id
		@host = Host.find host_id
		@booking = Booking.find booking_id
		@admin = Admin.first
		mail(to: @admin.email, subject: "A host has canceled a booking")
	end

	def guest_cancel(guest_id,host_id,booking_id)
		@guest = Guest.find guest_id
		@host = Host.find host_id
		@booking = Booking.find booking_id
		@admin = Admin.first
		mail(to: @admin.email, subject: "A guest has canceled a booking")
	end
end