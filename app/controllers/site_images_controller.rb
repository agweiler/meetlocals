class SiteImagesController < ApplicationController
	before_action :set_site_images, only: [:edit, :update]
	def index
		@siteimages = SiteImage.all.order(:image_number)
	end

	def new

	end

	def create

	end

	def edit
		@image_number = params["image_number"]
	end

	def update
		@site_image.delete if new_img = SiteImage.create!(local_image: params["site_image"]["image_file"], image_number: params["site_image"]["image_number"], name: params["site_image"]["name"])
		redirect_to site_images_path
	end

	private
		def set_site_images
			@site_image = SiteImage.find(params[:id])
		end
end
