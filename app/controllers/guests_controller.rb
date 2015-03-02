class GuestsController < ApplicationController
  before_action :set_guest, only: [:show, :edit, :update, :destroy, :update_guest_profile]

	def show
	end

	def index
		byebug
		@guests = Guest.all
	end

	# GET /guests/new
  def new
    redirect_to '/guests/sign_in' unless guest_signed_in?
    @guest = Guest.new
  end

  # GET /guests/1/edit
  def edit
  end

  # POST /guests
  def create
    @guest = Guest.new
    @image_file = guest_params.delete(:image_file)

    respond_to do |format|
      if @guest.save
        format.html { redirect_to guest, notice: 'Guest was successfully created.' }
        
        #create image after parent-guest is saved
        new_img = @experience.images.new
        new_img.image_file = @image_file
        new_img.caption = @image_file.original_filename
        new_img.save!
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /guests/1
  def update
  	@image_file = guest_params.delete(:image_file)
    @guest.update(guest_params.except(:image_file))
    if @guest.images.present?
      @guest.images.delete_all
    end
    new_img = @guest.images.new
    new_img.image_file = @image_file
    new_img.caption = @image_file.original_filename
    new_img.save!

    respond_to do |format|
      format.html { redirect_to edit_guest_profile, notice: 'Your guest profile was successfully updated.' }
    end
  end

  # DELETE /guests/1
  def destroy
  	if @guest.images.present?
      @guest.images.delete_all
    end
    @guest.destroy
    respond_to do |format|
      format.html { redirect_to guests_url, notice: 'Guest was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def edit_guest_profile #this is actually show
    @guest = Guest.find(params[:id])
  end

  def update_guest_profile #this is actually create and complete guest profile
    @image_file = guest_params.delete(:image_file)
    
    @guest.update(guest_params.except(:image_file))
    #ADRIAN_20150302 - added to support guest image upload
    if @guest.images.present?
      @guest.images.delete_all
    end
    new_img = @guest.images.new
    new_img.image_file = @image_file
    new_img.caption = @image_file.original_filename
    new_img.save!
    #ADRIAN_20150302 - end
    if @guest.save
      respond_to do |format| 
        format.html { redirect_to edit_guest_profile, notice: 'Guest profile was successfully updated.' }
      end
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_guest
    @guest = Guest.find(params[:id])
  end

	# Never trust parameters from the scary internet, only allow the white list through.
  def guest_params
    params.require(:guest).permit(:username, :email, :password, :password_confirmation, :about, :remember_me, :image_file)
  end
end
