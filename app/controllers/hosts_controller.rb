class HostsController < ApplicationController
    require 'pp'
    include ImagesHelper
	  before_action :set_host, only: [:show, :edit, :update, :destroy, :update_host_profile, :update_holiday]

  def index
		limit_per_page = 3
		session[:seed] ||= rand(10).round(2) / 10
		Host.connection.execute("select setseed(#{session[:seed]})")

    if (request.request_method == 'GET')
			@hosts = Host.where(approved: true).order('random()').includes(:images)
		elsif (request.request_method == 'POST')
      assign_search_inputs!
      @hosts = Host.search_by(search_params).includes(:images)
		end

		respond_to do |format|
	  	# format.html
	  	format.js
		end unless params[:page].nil?

  end

  def show
    @normal_events = @host.experiences.normal_events
		@special_events = @host.experiences.special_events
    @response = check_images_host(@host.id)
    @paid_exp = @host.bookings.where(status: 'completed').pluck(:group_size)
    respond_to do |format|
      format.js    { render json: @response }
      format.html
    end
  end


  def edit
    if no_one_signed_in?
      deny_access_host
      return
    end

    @experience = @host.experiences.find_or_initialize_by(date: nil)
    if @experience.id
      @image_1 = @experience.exp_images.find_by(image_number: 1)
      @image_2 = @experience.exp_images.find_by(image_number: 2)
      @image_3 = @experience.exp_images.find_by(image_number: 3)
    end
    @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: 201,  acl: :public_read).where(:content_type).starts_with("")
  end

  # PATCH/PUT /hosts/1
  def update
    # this commit param apparently is the name of the f.submit button
    if params[:commit] == "Approve User"
      @host.update(approved: true)
      Hostmailer.host_approved(@host.id).deliver_later
      redirect_to(:back)
    else
      @host = current_host || Host.find(params[:id])
      params[:host][:video_url].gsub!(/watch\?v=/,"embed/")
      @image_file = params[:host].delete(:image_file)
      @host.update(host_params.except(:image_file))

      if @image_file.present?
        if @host.images.present?
          @host.images.delete_all
        end
        Image.create(local_image: @image_file, caption: @image_file.original_filename, imageable: @host)
      end
        @experience = @host.experiences.find_or_initialize_by(date: nil)
        @image_files = []
        @image_files << params[:imageNumber0]
        @image_files << params[:imageNumber1]
        @image_files << params[:imageNumber2]
        experience_params[:price].replace((Price.find_by meal: experience_params[:meal]).price.to_s)
        if @experience.update(experience_params.except(:days))

          @image_files.each_with_index do |img, index|
            if img.is_a? String
              if @experience.exp_images.find_by(image_number: (index + 1)) != nil
                @experience.exp_images.find_by(image_number: (index + 1)).delete
              end
              new_img = @experience.exp_images.new
              new_img.temp_file_key = img
              new_img.image_number = index.to_i + 1
              new_img.save!
            end
          end unless @image_files.nil?
        end
      # this is so email will be sent only while admin needs to know
      if @host.approved == false
        Adminmailer.host_created(@host.id).deliver_later
        redirect_to create_host_success_path if current_host
        redirect_to admins_path, notice: "Update has been successful" if current_admin
      else
        if current_host
          redirect_to host_path(@host), notice: 'Your host profile was successfully updated.'
        else
          redirect_to admins_path, notice: "Update has been successful"
        end
      end
    end
  end

  # DELETE /hosts/1
  def destroy
    email = @host.email
    if @host.images.present?
      @host.images.delete_all
    end
    @host.experiences.each do |exp|
        exp.bookings.delete_all
    end
    @host.experiences.delete_all
    @host.notifications.delete_all
    approved = @host.approved
    @host.delete
    if current_admin && approved == false
      Hostmailer.host_rejected(email).deliver_later
      redirect_to admin_settings_path
    elsif current_admin && approved == true
      redirect_to admins_path
    else
      respond_to do |format|
        format.html { redirect_to admins_url, notice: 'host was successfully destroyed.' }
        format.json { head :no_content }
      end
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

	def update_holiday
		holiday = params[:holiday][:dates]

		# redirect_to host_path if @host.set_holiday(holiday)

		respond_to do |format|
			format.js
		end if @host.set_holiday(holiday)
	end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_host
      @host = Host.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def host_params
      params.require(:host).permit(:username, :email, :password, :password_confirmation, :country, :state, :image_file, :occupation, :interests, :smoker,:pets, :suburb, :latitude, :zip,
       :longitude, :title, :first_name, :last_name, :languages, :street_address, :host_presentation, :neighbourhood, :dob, :video_url, :phone,:registration_number, :bank_name, :bank_number,experiences_attributes: [:id, :title, :location, :datefrom, :dateto, :duration, :cuisine, :beverages, :max_group_size, :host_style, :available_days, :date, :price, :time, :meal, :mealset, :images_1, :images_2, :images_3, :_destroy])
    end

    def experience_params
      params.require(:experience).permit(:id, :title, :location, :datefrom, :dateto, :duration, :cuisine, :beverages, :max_group_size, :host_style, :available_days, :date, :price, :time, :meal, :mealset)
    end

    def search_params
      params.require(:search).permit(:date, :age_range, :max_group, :location)
    end

    def assign_search_inputs!
      @selected_age = search_params[:age_range]
      @selected_location = search_params[:location]
      @selected_group = search_params[:max_group]
      @selected_date = search_params[:date]
    end

end
