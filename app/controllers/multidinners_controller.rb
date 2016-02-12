class MultidinnersController < ApplicationController
	def new
		
		@multidinner = Multidinner.new
		@host = Host.all
		@id = params[:id]
	end

	def create
		
		x = 1
		grp_size = []
		hosts = []
		while x < 11
			group_size = params["group_size_#{x}"]
			if group_size != ""
				grp_size << group_size
			end
			host_chosen = params["choose_host_#{x}"]
			if host_chosen != ""
				hosts << host_chosen
			end
			x = x + 1
		end
		partner = Partner.find params[:id]
		new_multidinner = partner.multidinners.new
		new_multidinner.update(multidinner_params)
		new_multidinner.group_sizes = grp_size
		new_multidinner.hosts_chosen = hosts
		new_multidinner.save
		redirect_to "/"
	end

	private

		def multidinner_params
			params.require(:multidinner).permit(:name, :date,)
		end
end
