class PartnersController < ApplicationController

	def index
	end

	def show
	end

	def new
	end

	def create
	end

	def edit
	end

	private

		def partner_params
			params.require(:partner).permit(:name, :contact_info, :address)
		end
end
