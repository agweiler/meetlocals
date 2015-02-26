class ExperiencesController < ApplicationController
  before_action :set_experience, only: [:show, :edit, :update, :destroy]

  # GET /experiences
  # GET /experiences.json
  def index
    @experiences = Experience.all
  end

  # GET /experiences/1
  # GET /experiences/1.json
  def show
  end

  # GET /experiences/new
  def new
    redirect_to '/hosts/sign_in' unless host_signed_in?
    @experience = Experience.new
    @experience.available_days = "0000000"
  end

  # GET /experiences/1/edit
  def edit
  end

  # POST /experiences
  # POST /experiences.json
  def create

    @days = experience_params.delete(:days)
    default = "0000000"

    (0..6).each do |num|
        default[num] =  "1" if experience_params[:days][num.to_s] == "1"
    end

    experience_params[:available_days].replace(default)

    @image_files = experience_params.delete(:images_array)

    @experience = current_host.experiences.new(experience_params.except(:images_array, :days))

    respond_to do |format|
      if @experience.save
        format.html { redirect_to @experience, notice: 'Experience was successfully created.' }
        # format.json { render :show, status: :created, location: @experience }

        #create image after parent-experience is saved
        @image_files.each do |img|
          new_img = @experience.images.new
          new_img.image_file = img
        # img.title = @image_file.original_filename #this column serves no purpose, suggest to delete it via migration to images table
          new_img.caption = img.original_filename
          new_img.save!
        end unless @image_files.nil?
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /experiences/1
  # PATCH/PUT /experiences/1.json
  def update

    @days = experience_params.delete(:days)
    default = "0000000"

    (0..6).each do |num|
        default[num] =  "1" if experience_params[:days][num.to_s] == "1"
    end

    experience_params[:available_days].replace(default)

    @image_files = experience_params.delete(:images_array)

    respond_to do |format|
      if @experience.update(experience_params.except(:images_array, :days))
        format.html { redirect_to @experience, notice: 'Experience was successfully updated.' }
        # format.json { render :show, status: :ok, location: @experience }

        #reset image(s) after parent-experience is save
        if @experience.images.present?
          @experience.images.delete_all
        end

        @image_files.each do |img|
          new_img = @experience.images.new
          new_img.image_file = img
        # img.title = @image_file.original_filename #this column serves no purpose, suggest to delete it via migration to images table
          new_img.caption = img.original_filename
          new_img.save!
        end
      else
        format.html { render :edit }
        # format.json { render json: @experience.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /experiences/1
  # DELETE /experiences/1.json
  def destroy
    @experience.destroy
    respond_to do |format|
      format.html { redirect_to experiences_url, notice: 'Experience was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_experience
      @experience = Experience.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def experience_params
      params.require(:experience).permit(:title, :description, :duration, :is_halal, :cuisine, :max_group_size, :host_style, :available_days, :price, :images_array => [],
      #  days: [:sun, :mon, :tue, :wed, :thu, :fri, :sat],
       days: ["0","1","2","3","4","5","6"])
    end
end
