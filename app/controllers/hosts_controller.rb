class HostsController < ApplicationController
	  before_action :set_host, only: [:show, :edit, :update, :destroy, :update_host_profile]

  def index
    @host = Host.all
  end

  def show
    @host = Host.find(params[:id])
    @experiences = @host.experiences.order(:active)
  end

  def new
    @host = Host.new
  end

  def edit
  end

  # POST /hosts
  # We don't seem to be using this...
  def create
    # @host = Host.new(host_detail_params)

    # @image_file = params[:host].delete(:image_file)

    # respond_to do |format|
    #   if @host.save
    #     format.html { redirect_to host, notice: 'host was successfully created.' }

    #     # Create image after parent-host is saved
    #     new_img = @host.images.new
    #     new_img.image_file = @image_file
    #     new_img.caption = @image_file.original_filename
    #     new_img.save!
    #     new_img.update(imageable:@host)
    #   else
    #     format.html { render :new }
    #   end
    # end
  end

  # PATCH/PUT /hosts/1
  def update
    @image_file = params[:host].delete(:image_file)
    @host.update(host_params.except(:image_file))
    if @image_file.present?
      if @host.images.present?
        @host.images.delete_all
      end
      Image.create(local_image: @image_file, caption: @image_file.original_filename, imageable: @host)
    end
    respond_to do |format|
      format.html { redirect_to edit_host_profile, notice: 'Your host profile was successfully updated.' }
    end
  end

  # DELETE /hosts/1
  def destroy
    if @host.images.present?
      @host.images.delete_all
    end
    @host.destroy
    respond_to do |format|
      format.html { redirect_to hosts_url, notice: 'host was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def edit_host_profile # Edit profile page
  	if current_host == nil
  	  deny_access_host
    else
      @host = Host.find(params[:id])
    end
  end

  def update_host_profile # Create and Edit host profile
    @image_file = params[:host].delete(:image_file)
    if @image_file.present?
      if @host.images.present?
        @host.images.delete_all
      end
      Image.create(local_image: @image_file, caption: @image_file.original_filename, imageable: @host)
    end
    puts "preparing for host update"
    if @host.update(host_params.except(:image_file))
      puts "updating host"
      respond_to do |format|
        format.html { redirect_to edit_host_profile, notice: 'host profile was successfully updated.' }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_host
      @host = Host.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def host_params
      params.require(:host).permit(:username, :email, :password, :password_confirmation, :country, :state, :image_file, :occupation, :interests, :smoker,:pets, :suburb, :latitude, :longitude, :title, :first_name, :last_name, :languages, :street_adress, :intro, :neighbourhood, :additional_info, :dob, :video_url )
    end
end
