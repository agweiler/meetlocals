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
	end

	def changeprice
		price = Price.find params[:format]
		price.update(price: params[:price][:price])
		Experience.where(meal: price.meal).update_all(price: params[:price][:price])
		redirect_to "/"
	end
end
