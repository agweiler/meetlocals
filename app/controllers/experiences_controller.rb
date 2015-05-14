class ExperiencesController < ApplicationController
  include ExperiencesHelper
  before_action :set_experience, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json

  # GET /experiences
  def index
    # Date.strptime('April 13, 2015',"%B %d, %Y")
    datefrom = Date.strptime(params[:dateFR],"%B %d, %Y") unless params[:dateFR] == '' || params[:dateFR].nil?
    dateto = Date.strptime(params[:dateTO],"%B %d, %Y") unless params[:dateTO] == '' || params[:dateTO].nil?

    @group_size = params[:max_group_size]
    @group_size ||= 1
    @location = params[:experience][:location] unless params[:experience].nil?
    @input_datefrom, @input_dateto = datefrom, dateto

    @input_datefrom ||= @input_dateto
    @input_dateto ||= @input_datefrom

    dayto, dayfrom = -1, -1
    dateto, datefrom, datediff = -1, -1, -1
    datefrom, dateto = @input_datefrom, @input_dateto
    dateto ||= datefrom
    datefrom ||= dateto

    unless @input_datefrom.nil? && @input_dateto.nil?
      datediff = (dateto - datefrom).to_i + 1 if dateto >= datefrom
      datediff ||= (datefrom - dateto).to_i + 1 if datefrom > dateto

      # allday = [0,1,2,3,4,5,6]
      dayfrom = @input_datefrom.strftime('%w').to_i
      dayto = @input_dateto.strftime('%w').to_i
    end

    if ( (params[:experience] == nil || @location == "All") && datediff >= 7 )
      @experiences = Experience.where("max_group_size >= ? AND active = true", @group_size)
    elsif ( (params[:experience] == nil || @location == "All") && (!params[:dateFR].present? && !params[:dateTO].present?) )
      @experiences = Experience.where("max_group_size >= ? AND active = true", @group_size)
    elsif ( (params[:experience] != nil && @location != "All") && (!params[:dateFR].present? && !params[:dateTO].present?) )
      # @experiences = Experience.where(location: @location)
      @experiences = Experience.where("location = ? AND max_group_size = ? AND active = true",
        @location, @group_size)
    else # date(s) + with/without @location
      from_to = []
      if dayfrom == dayto
        from_to = (dayfrom .. dayto).to_a
      elsif dayfrom > dayto
        datefrom > dateto ? from_to = (dayto .. dayfrom).to_a : from_to = (dayfrom .. 6).to_a + (0..dayto).to_a
        # from_to = (dayto .. dayfrom).to_a if datefrom > dateto
        # from_to = (dayfrom .. 6).to_a + (0..dayto).to_a if from_to.empty?
      elsif dayto >= dayfrom
        datefrom < dateto ? from_to = (dayfrom .. dayto).to_a : from_to = (dayto .. 6).to_a + (0..dayfrom).to_a
        # from_to = (dayfrom .. dayto).to_a unless datefrom > dateto
        # from_to = (dayto .. 6).to_a + (0..dayfrom).to_a if from_to.empty?
      end

      strlike = "(" + from_to.map { | day | "available_days LIKE '%" + day.to_s + "%'" }.join(' OR ') + ")"
      # strlike = "(" + arrlike.join(' OR ') + ")"

      strloc = "max_group_size >= #{@group_size}"
      strloc += "AND location = '#{@location}'" unless
        (params[:experience] == nil || params[:experience][:location] == 'All')
      # (params[:experience] == nil || params[:experience][:location] == 'All') ? strloc = '' : strloc = "location = '#{params[:experience][:location]}'"

      strloc += ' AND ' if strloc.present? && strlike.present?

      stractive += " AND active = 'true'"

      # @experiences = Experience.where(location: params[:experience][:location])
      @experiences = Experience.where("#{strloc}" + "#{strlike}" +
      "#{stractive}").order(available_days: :desc)
      @location ||= 'All' unless @location.present?
    end
  end

  # GET /experiences/1
  def show

  	@booking = Booking.new
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
    @experience = Experience.new
  end

  # GET /experiences/1/edit
  def edit
    if host_signed_in?
      redirect_to '/' unless current_host.id == @experience.host_id
    else
      redirect_to '/hosts/sign_in'
    end
  end

  # POST /experiences
  def create

    @days = experience_params.delete(:days)
    default = "-------"

    (0..6).each do |num|
        default[num] =  num.to_s if experience_params[:days][num.to_s] == "1"
    end
    experience_params[:available_days].replace(default)
    @image_files = experience_params.delete(:images_array)
    experience_params[:price].replace((Price.find_by meal: experience_params[:meal]).price.to_s)
    @experience = current_host.experiences.new(experience_params.except(:images_array, :days))
    if @experience.save
      redirect_to @experience, notice: 'Experience was successfully created.'
      #create image after parent-experience is saved
      @image_files.each do |img|
        new_img = @experience.images.new
        new_img.local_image = img
      # img.title = @image_file.original_filename #this column serves no purpose, suggest to delete it via migration to images table
        new_img.caption = img.original_filename
        new_img.save!
      end unless @image_files.nil?
    else
      render :new
    end
  end

  # PATCH/PUT /experiences/1
  def update

    @days = experience_params.delete(:days)
    default = "-------"

    (0..6).each do |num|
        default[num] =  num.to_s if experience_params[:days][num.to_s] == "1"
    end

    experience_params[:available_days].replace(default)
    @image_files = experience_params.delete(:images_array)
      if @experience.update(experience_params.except(:images_array, :days))
        redirect_to @experience, notice: 'Experience was successfully updated.'

        #reset image(s) after parent-experience is save
        if @experience.images.present?
          @experience.images.delete_all
        end

        @image_files.each do |img|
          new_img = @experience.images.new
          new_img.local_image = img
        # img.title = @image_file.original_filename #this column serves no purpose, suggest to delete it via migration to images table
          new_img.caption = img.original_filename
          new_img.save!
        end unless @image_files.nil?
      else
        render :edit
      end
  end

  # DELETE /experiences/1
  def destroy
    # @experience.destroy
    @experience.to_inactive
    redirect_to experiences_url, notice: 'Experience was successfully destroyed.'
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_experience
      @experience = Experience.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def experience_params
      params.require(:experience).permit(:title, :location, :datefrom, :dateto, :description, :duration, :cuisine, :beverages, :max_group_size, :host_style, :available_days, :date, :price, :time, :meal, :mealset, :images_array => [],
      #  days: [:sun, :mon, :tue, :wed, :thu, :fri, :sat],
       days: ["0","1","2","3","4","5","6"])
    end
end
