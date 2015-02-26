class GuestsController < ApplicationController
	def show
		@guest = Guest.find(params[:id])
	end

	def index
		@guests = Guest.all
	end
end
