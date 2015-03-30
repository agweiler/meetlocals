class AdminsController < ApplicationController
	def index
		@admins = Admin.all
		@guests = Guest.all
		@hosts = Host.all
		@bookings = Booking.all
	end
end
