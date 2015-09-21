class AdminsController < ApplicationController
	include AdminsHelper
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
		@requested_bookings = Booking.where(status: "requested").reverse_order.pluck(:id,:guest_id,:experience_id,:date,:group_size,:created_at).take(10)
		@invited_bookings = Booking.where(status: "invited").reverse_order.pluck(:id,:guest_id,:experience_id,:date,:group_size,:created_at).take(10)
		@confirmed_bookings = Booking.where(status: "confirmed").reverse_order.pluck(:id,:guest_id,:experience_id,:date,:group_size,:created_at,:host_paid).take(10)
		@completed_bookings = Booking.where(status: "completed").reverse_order.pluck(:id,:guest_id,:experience_id,:date,:group_size,:created_at).take(10)
	end

	def changeprice
		price = Price.find params[:format]
		if price.meal.include? "Host_Party_"
			price.meal.slice! "Host_Party_"
			Experience.where.not(date: nil).where(meal: price.meal).update_all(price: params[:price][:price])
		else	
			price.update(price: params[:price][:price])
			Experience.where(meal: price.meal).update_all(price: params[:price][:price])
		end
		redirect_to(:back)
	end

	def update
		Admin.first.update(admin_params)
		redirect_to(:back)
	end

	def approveuser
		host = Host.find params[:format]
		host.update(approved: true)
		redirect_to(:back)
	end

	def booking_type_all
		booking_type = "@#{params[:status]}_bookings"
		instance_variable_set(booking_type , Booking.where(status: params[:status]).reverse_order.pluck(:id,:guest_id,:experience_id,:date,:group_size,:created_at)) unless params[:status] == "confirmed"
		instance_variable_set(booking_type , Booking.where(status: "confirmed").reverse_order.pluck(:id,:guest_id,:experience_id,:date,:group_size,:created_at,:host_paid)) if params[:status] == "confirmed"
	end

	def report
		@bookings = Booking.where(status: "confirmed").where(date: params[:range].to_date..Date.today + 1.month)
		respond_to do |format|
			format.csv { send_data convert_to_csv(@bookings), filename: "Report from #{params[:range].to_date} to #{Date.today}.csv"}
		end
	end

	private
		def admin_params
		  params.require(:admin).permit(:commision_percentage)
		end
end
