class AdminsController < ApplicationController
	def index
		@admins = Admin.all
		@guests = Guest.all
		@hosts = Host.all
	end

	def analytics
	end

	def settings
		@prices = Price.all
		@hosts = Host.where(approved: false)
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
