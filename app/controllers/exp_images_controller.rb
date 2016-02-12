class ExpImagesController < ApplicationController
	# GET /images/new
	def new
	  @image = ExpImage.new
	end

	def create
	  @image = ExpImage.new(image_params)

	  respond_to do |format|
	    if @image.save
	      format.html { redirect_to @image, notice: 'Image was successfully created.' }
	      format.json { render :show, status: :created, location: @image }
	    else
	      format.html { render :new }
	      format.json { render json: @image.errors, status: :unprocessable_entity }
	    end
	  end
	end

	# PATCH/PUT /images/1
	# PATCH/PUT /images/1.json
	def update
	  respond_to do |format|
	    if @image.update(image_params)
	      format.html { redirect_to @image, notice: 'Image was successfully updated.' }
	      format.json { render :show, status: :ok, location: @image }
	    else
	      format.html { render :edit }
	      format.json { render json: @image.errors, status: :unprocessable_entity }
	    end
	  end
	end
end
