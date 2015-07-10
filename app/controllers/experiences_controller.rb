class ExperiencesController < ApplicationController
  include ExperiencesHelper
  require 'paypal-sdk-adaptivepayments'
  before_action :set_experience, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json

  # GET /experiences
  def index

    redirect_to hosts_path
    # # Date.strptime('April 13, 2015',"%B %d, %Y")
    #
    # datefrom = Date.strptime(params[:dateFR],"%B %d, %Y") unless params[:dateFR] == '' || params[:dateFR].nil?
    # dateto = Date.strptime(params[:dateTO],"%B %d, %Y") unless params[:dateTO] == '' || params[:dateTO].nil?
    #
    # @group_size = params[:max_group_size]
    # # @group_size ||= 1
    # @group_size = nil if @group_size.blank?
    # @location = params[:experience][:location] unless params[:experience].nil?
    # @input_datefrom, @input_dateto = datefrom, dateto
    #
    # @input_datefrom ||= @input_dateto
    # @input_dateto ||= @input_datefrom
    #
    # dayto, dayfrom = -1, -1
    # dateto, datefrom, datediff = -1, -1, -1
    # datefrom, dateto = @input_datefrom, @input_dateto
    # dateto ||= datefrom
    # datefrom ||= dateto
    #
    # unless @input_datefrom.nil? && @input_dateto.nil?
    #   datediff = (dateto - datefrom).to_i + 1 if dateto >= datefrom
    #   datediff ||= (datefrom - dateto).to_i + 1 if datefrom > dateto
    #
    #   # allday = [0,1,2,3,4,5,6]
    #   dayfrom = @input_datefrom.strftime('%w').to_i
    #   dayto = @input_dateto.strftime('%w').to_i
    # end
    #
    # if ( (params[:experience] == nil || @location == "Region") && datediff >= 7 )
    #   @experiences = Experience.where("max_group_size >= ?", @group_size || 1)
    # elsif ( (params[:experience] == nil || @location == "Region") && (!params[:dateFR].present? && !params[:dateTO].present?) )
    #   @experiences = Experience.where("max_group_size >= ?", @group_size || 1)
    # elsif ( (params[:experience] != nil && @location != "Region") && (!params[:dateFR].present? && !params[:dateTO].present?) )
    #   # @experiences = Experience.where(location: @location)
    #   @experiences = Experience.where("location = ? AND max_group_size >= ?",
    #     @location, @group_size || 1)
    # else # date(s) + with/without @location
    #   from_to = []
    #   if dayfrom == dayto
    #     from_to = (dayfrom .. dayto).to_a
    #   elsif dayfrom > dayto
    #     datefrom > dateto ? from_to = (dayto .. dayfrom).to_a : from_to = (dayfrom .. 6).to_a + (0..dayto).to_a
    #     # from_to = (dayto .. dayfrom).to_a if datefrom > dateto
    #     # from_to = (dayfrom .. 6).to_a + (0..dayto).to_a if from_to.empty?
    #   elsif dayto >= dayfrom
    #     datefrom < dateto ? from_to = (dayfrom .. dayto).to_a : from_to = (dayto .. 6).to_a + (0..dayfrom).to_a
    #     # from_to = (dayfrom .. dayto).to_a unless datefrom > dateto
    #     # from_to = (dayto .. 6).to_a + (0..dayfrom).to_a if from_to.empty?
    #   end
    #
    #   strlike = "(" + from_to.map { | day | "available_days LIKE '%" + day.to_s + "%'" }.join(' OR ') + ")"
    #   # strlike = "(" + arrlike.join(' OR ') + ")"
    #
    #   strloc = "max_group_size >= #{(@group_size || 1)}"
    #   strloc += "AND location = '#{@location}'" unless
    #     (params[:experience] == nil || params[:experience][:location] == 'Region')
    #   # (params[:experience] == nil || params[:experience][:location] == 'Region') ? strloc = '' : strloc = "location = '#{params[:experience][:location]}'"
    #
    #   strloc += ' AND ' if strloc.present? && strlike.present?
    #
    #   # @experiences = Experience.where(location: params[:experience][:location])
    #   @experiences = Experience.where("#{strloc}" + "#{strlike}").order(available_days: :desc)
    #   @location ||= 'Region' unless @location.present?
    # end
  end

  # GET /experiences/1
  def show

  	@booking = Booking.new

    if @experience.special_event?
      @endDate = @startDate = @experience.date.strftime('%F')
    else
      @startDate = (Date.today + 5.days).strftime('%F')
      @endDate = (Date.today + 6.months).strftime('%F')
    end

    # @testimonials = @experience.bookings.map { |booking| booking.testimonial }.compact
    @testimonials = @experience.testimonials #associate Experience-Testimonials
    # @average_rating = @experience.bookings.joins(:testimonial).select('AVG(rating) as average').first.average
    @average_rating = @experience.avg_rating if @experience.testimonials.present?
    @response = check_images(@experience.id)
    respond_to do |format|
      format.js    { render json: @response }
      format.html
    end
  end

  # GET /experiences/new
  def new
    redirect_to '/hosts/sign_in' unless host_signed_in?
    @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: 201,  acl: :public_read).where(:content_type).starts_with("")
    @experience = Experience.new
    @host = current_host
  end

  # GET /experiences/1/edit
  def edit
    if host_signed_in?
      redirect_to '/' unless current_host.id == @experience.host_id
      @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: 201,  acl: :public_read).where(:content_type).starts_with("")
    else
      redirect_to '/hosts/sign_in'
    end
  end

  # POST /experiences
  def create

    # @days = experience_params.delete(:days)
    # default = "-------"
    #
    # (0..6).each do |num|
    #     default[num] =  num.to_s if experience_params[:days][num.to_s] == "1"
    # end
    # experience_params[:available_days].replace(default)
    
    @image_files = experience_params.delete(:images_array)
    experience_params[:price].replace((Price.find_by meal: experience_params[:meal]).price.to_s)
    @experience = current_host.experiences.new(experience_params.except(:images_array, :days))
    if @experience.save
      redirect_to @experience, notice: 'Experience was successfully created.'
      #create image after parent-experience is saved

      @image_files.each do |img|
        new_img = @experience.images.new
        if img.is_a? String
        new_img.temp_file_key = img
        new_img.save!
        end
      end unless @image_files.nil?
    else
       render :new
    end
  end

  # PATCH/PUT /experiences/1
  def update

    # @days = experience_params.delete(:days)
    # default = "-------"
    #
    # (0..6).each do |num|
    #     default[num] =  num.to_s if experience_params[:days][num.to_s] == "1"
    # end
    # experience_params[:available_days].replace(default)

    @image_files = experience_params.delete(:images_array)
      if @experience.update(experience_params.except(:images_array, :days))
        redirect_to @experience, notice: 'Experience was successfully updated.'

        #reset image(s) after parent-experience is save
        if @experience.images.present? && !@image_files.nil?
          @experience.images.delete_all
        end

        @image_files.each do |img|
          new_img = @experience.images.new
          if img.is_a? String
          new_img.temp_file_key = img
          new_img.save!
          end
        end unless @image_files.nil?
      else
        render :edit
      end
  end

  # DELETE /experiences/1
  def destroy
    @experience.destroy
    redirect_to experiences_url, notice: 'Experience was successfully destroyed.'
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_experience
      @experience = Experience.find(params[:id])
      @host = @experience.host
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def experience_params
      params.require(:experience).permit(:title, :location, :datefrom, :dateto, :description, :duration, :cuisine, :beverages, :max_group_size, :host_style, :available_days, :date, :price, :time, :meal, :mealset, :images_array => [],
      #  days: [:sun, :mon, :tue, :wed, :thu, :fri, :sat],
       days: ["0","1","2","3","4","5","6"])
    end
end
