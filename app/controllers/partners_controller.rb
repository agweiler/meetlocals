class PartnersController < ApplicationController
	def index
		@partners = Partner.all
	end

	def show
		@partner = Partner.find params[:id]
		@multidinners = @partner.multidinners.all
	end

	def edit
		@partner = Partner.find params[:id]
	end

	def bookings
		@host = Host.all
		@booking = Booking.new
	end

	def create_booking
	
		x = 1
		grp_size = []
		hosts = []
		while x < 11
			group_size = params["group_size_#{x}"]
			if group_size != ""
				grp_size << group_size
			end
			host_chosen = params["choose_host_#{x}"]
			if host_chosen != ""
				hosts << host_chosen
			end
			x = x + 1
		end
		

	end
end
