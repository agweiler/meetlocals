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
		@requested_bookings = Booking.where(status: "requested").reverse_order.pluck(:id,:guest_id,:experience_id,:date,:group_size,:created_at)
		@invited_bookings = Booking.where(status: "invited").reverse_order.pluck(:id,:guest_id,:experience_id,:date,:group_size,:created_at)
		@confirmed_bookings = Booking.where(status: "confirmed").reverse_order.pluck(:id,:guest_id,:experience_id,:date,:group_size,:created_at)
		@completed_bookings = Booking.where(status: "completed").reverse_order.pluck(:id,:guest_id,:experience_id,:date,:group_size,:created_at)
	end

	def changeprice
		price = Price.find params[:format]
		price.update(price: params[:price][:price])
		Experience.where(meal: price.meal).update_all(price: params[:price][:price])
		redirect_to(:back)
	end

	def update
		Admin.first.update(admin_params)
		redirect_to(:back)
	end

	def approveuser
		host = Host.find params[:format]
		host.update(approved: true)
		redirect_to "/"
	end

	private
		def admin_params
		  params.require(:admin).permit(:commision_percentage)
		end
end
