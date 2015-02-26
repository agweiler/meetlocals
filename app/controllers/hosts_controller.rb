class HostsController < ApplicationController
	  before_action :set_host, only: [:show, :edit, :update, :destroy]

  # GET /bookings
  # GET /bookings.json
  def index
    @host = Host.all #might need at bookings instead
  end

  # GET /hosts/1
  # GET /hosts/1.json
  def show
    @host = Host.find(params[:id])
  end

  # GET /hosts/new
  def new
    @host = Host.new
  end

  # GET /hosts/1/edit
  def edit
  end

  # POST /hosts
  # POST /hosts.json
  def create
    @host = Host.new(host_params)

    # respond_to do |format|
      if @host.save
        format.html { redirect_to create_host_profile_path, notice: 'host was successfully created.' }
    #   else
    #     format.html { render :new }
    #   end
    end
  end

  # PATCH/PUT /hosts/1
  # PATCH/PUT /hosts/1.json
  def update
    respond_to do |format|
      if @host.update(host_params)
        format.html { redirect_to @host, notice: 'host was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /hosts/1
  # DELETE /hosts/1.json
  def destroy
    @host.destroy
    respond_to do |format|
      format.html { redirect_to hosts_url, notice: 'host was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def edit_host_profile
    @host = Host.find(params[:id])
  end

  def update_host_profile
    @host = Host.find(params[:id])
    # @host.update()
    @host.update(host_detail_params)
    if @host.save
    redirect_to host_path(@host)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_host
      @host = Host.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def host_params
      params.require(:host).permit(:start_time, :end_time, :date, :guest_id, :experience_id, :status, :group_size, :is_private, :rating)
    end

    def host_detail_params
      params.require(:host).permit(:username, :email, :password,
                                 :password_confirmation, :DOB, :country, :state, :suburb)
    end
end
