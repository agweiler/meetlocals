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
    @experience = Experience.new
  end

  # GET /experiences/1/edit
  def edit
  end

  # POST /experiences
  # POST /experiences.json
  def create
    @image_file = experience_params.delete(:image_file)
    @experience = Experience.new(experience_params.except(:image_file))
    # @experience = current_host.experiences.new(experience_params.except(:image_file))

    respond_to do |format|
      if @experience.save
        format.html { redirect_to @experience, notice: 'Experience was successfully created.' }
        format.json { render :show, status: :created, location: @experience }

        #create image after parent-experience is saved
        @experience.images.create(image_file: @image_file)
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /experiences/1
  # PATCH/PUT /experiences/1.json
  def update
    @image_file = experience_params.delete(:image_file)

    respond_to do |format|
      if @experience.update(experience_params.except(:image_file))
        format.html { redirect_to @experience, notice: 'Experience was successfully updated.' }
        format.json { render :show, status: :ok, location: @experience }

        #update image after parent-experience is save
        @experience.images.first.update_attributes(image_file: @image_file)
      else
        format.html { render :edit }
        format.json { render json: @experience.errors, status: :unprocessable_entity }
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
      params.require(:experience).permit(:title, :description, :duration, :is_halal, :cuisine, :max_group_size, :host_style, :available_days, :price, :image_file, :host_id)
    end
end
