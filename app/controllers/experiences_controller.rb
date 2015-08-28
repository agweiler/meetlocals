class ExperiencesController < ApplicationController
  include ExperiencesHelper
  require 'paypal-sdk-adaptivepayments'
  before_action :set_experience, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json

  # GET /experiences
  def index
    redirect_to hosts_path
  end

  # GET /experiences/1
  def show

  	@booking = Booking.new
    @images_for_experiences = @experience.exp_images.limit(3).order(:image_number)
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
    puts "#########################"
    puts @s3_direct_post
    @experience = Experience.new
    @host = current_host
  end

  # GET /experiences/1/edit
  def edit
    if host_signed_in?
      redirect_to '/' unless current_host.id == @experience.host_id
      @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: 201,  acl: :public_read).where(:content_type).starts_with("")
      @image_1 = @experience.exp_images.find_by(image_number: 1)
      @image_2 = @experience.exp_images.find_by(image_number: 2)
      @image_3 = @experience.exp_images.find_by(image_number: 3)
    else
      redirect_to '/hosts/sign_in'
    end
  end

  # POST /experiences
  def create
    @image_files = []
    @image_files << experience_params.delete(:images_1)
    @image_files << experience_params.delete(:images_2)
    @image_files << experience_params.delete(:images_3)
    experience_params[:price].replace((Price.find_by meal: experience_params[:meal]).price.to_s)
    @experience = current_host.experiences.new(experience_params.except(:images_1,:images_2,:images_3,:days))
    if @experience.save!
      redirect_to @experience, notice: 'Experience was successfully created.'
      #create image after parent-experience is saved
      @image_files.each_with_index do |img,index|
        if img.is_a? String
          new_img = @experience.exp_images.new
          new_img.temp_file_key = img
          new_img.image_number = index.to_i + 1
          new_img.save!
        end
      end unless @image_files.nil?
    else
       redirect_to new_experience_path
    end
  end

  # PATCH/PUT /experiences/1
  def update
    @image_files = []
    @image_files << experience_params.delete(:images_1)
    @image_files << experience_params.delete(:images_2)
    @image_files << experience_params.delete(:images_3)

    if @experience.update(experience_params.except(:images_1,:images_2,:images_3,:days))
      redirect_to @experience, notice: 'Experience was successfully updated.'

      puts "@@@@@@@@@@@@@@@@@@@@@@@@@"
      puts "#{Time.now}"
      puts "@@@@@@@@@@@@@@@@@@@@@@@@@"
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
      puts "@@@@@@@@@@@@@@@@@@@@@@@@@"
      puts "#{Time.now}"
      puts "@@@@@@@@@@@@@@@@@@@@@@@@@"
    else
        render :edit
    end
  end

  # DELETE /experiences/1
  def destroy
    @experience.destroy
    redirect_to @host, notice: 'Experience was successfully destroyed.'
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_experience
      @experience = Experience.find(params[:id])
      @host = @experience.host
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def experience_params
      params.require(:experience).permit(:title, :location, :datefrom, :dateto, :description, :duration, :cuisine, :beverages, :max_group_size, :host_style, :available_days, :date, :price, :time, :meal, :mealset, :images_1, :images_2, :images_3,
      #  days: [:sun, :mon, :tue, :wed, :thu, :fri, :sat],
       days: ["0","1","2","3","4","5","6"])
    end
end
