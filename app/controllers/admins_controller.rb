class AdminsController < ApplicationController
	def index
		@guests = Guest.all
		@hosts = Host.all
	end
end
