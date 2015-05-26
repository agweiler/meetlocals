class RegistrationsController < Devise::RegistrationsController
	private
		def partner_params
			params.require(:partner).permit(:name, :contact_info, :address)
		end
end
