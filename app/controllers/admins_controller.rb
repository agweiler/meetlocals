class AdminsController < ApplicationController
	def index
		redirect_to "/" unless current_admin
		@admins = Admin.all
		@guests = Guest.all
		@hosts = Host.all
	end

	def analytics
		redirect_to "/" unless current_admin
	end
	
	def settings
		redirect_to "/" unless current_admin
		@prices = Price.all
		@hosts = Host.where(approved: false)
	end

	def bookings_list
		redirect_to "/" unless current_admin
		@requested_bookings = Booking.where(status: "requested").pluck(:id,:guest_id,:experience_id,:date,:group_size,:created_at)
		@invited_bookings = Booking.where(status: "invited").pluck(:id,:guest_id,:experience_id,:date,:group_size,:created_at)
		@confirmed_bookings = Booking.where(status: "confirmed").pluck(:id,:guest_id,:experience_id,:date,:group_size,:created_at)
		@completed_bookings = Booking.where(status: "completed").pluck(:id,:guest_id,:experience_id,:date,:group_size,:created_at)
	end

	def changeprice
		price = Price.find params[:format]
		price.update(price: params[:price][:price])
		Experience.where(meal: price.meal).update_all(price: params[:price][:price])
		redirect_to "/"
	end

	def approveuser
		host = Host.find params[:format]
		host.update(approved: true)
		redirect_to "/"
	end
end
