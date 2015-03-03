class TestimonialsController < ApplicationController
  before_action :set_testimonial, only: [:show, :edit, :update, :destroy]

  # GET /testimonials
  # GET /testimonials.json
  def index
    @testimonials = Testimonial.all
  end

  # GET /testimonials/1
  # GET /testimonials/1.json
  def show
    @booking = @testimonial.booking
  end

  # GET /testimonials/new
  def new
    @testimonial = Testimonial.new
    @booking = Booking.find(params[:id])
  end

  # GET /testimonials/1/edit
  def edit
    @booking = @testimonial.booking
  end

  # POST /testimonials
  # POST /testimonials.json
  def create

    @image_files = testimonial_params.delete(:images_array)

    @testimonial = Testimonial.new(testimonial_params.except(:images_array))

    respond_to do |format|
      if @testimonial.save
        format.html { redirect_to @testimonial, notice: 'Testimonial was successfully created.' }
        # format.json { render :show, status: :created, location: @testimonial }

        #create image after parent-testimonial is saved
        @image_files.each do |img|
          new_img = @testimonial.images.new
          new_img.image_file = img
        # img.title = @image_file.original_filename #this column serves no purpose, suggest to delete it via migration to images table
          new_img.caption = img.original_filename
          new_img.save!
        end unless @image_files.nil?
      else
        format.html { render :new }
        # format.json { render json: @testimonial.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /testimonials/1
  # PATCH/PUT /testimonials/1.json
  def update

    @image_files = testimonial_params.delete(:images_array)

    respond_to do |format|
      if @testimonial.update(testimonial_params.except(:images_array))
        format.html { redirect_to @testimonial, notice: 'Testimonial was successfully updated.' }
        # format.json { render :show, status: :ok, location: @testimonial }

        #reset image(s) after parent-experience is save
        if @testimonial.images.present?
          @testimonial.images.delete_all
        end

        @image_files.each do |img|
          new_img = @testimonial.images.new
          new_img.image_file = img
        # img.title = @image_file.original_filename #this column serves no purpose, suggest to delete it via migration to images table
          new_img.caption = img.original_filename
          new_img.save!
        end unless @image_files.nil?
      else
        format.html { render :edit }
        # format.json { render json: @testimonial.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /testimonials/1
  # DELETE /testimonials/1.json
  def destroy
    @testimonial.destroy
    respond_to do |format|
      format.html { redirect_to testimonials_url, notice: 'Testimonial was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_testimonial
      @testimonial = Testimonial.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def testimonial_params
      params.require(:testimonial).permit(:title, :body, :booking_id, images_array:[])
    end
end
