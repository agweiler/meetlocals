module ImagesHelper
	def check_images_host(id)
		host = Host.find(id)
		if host.images.present?
			if host.images.first.image_file_file_name == ""
				false
			else
				true
			end
		end
	end

	def check_images_guest(id)
		guest = Guest.find(id)
		if guest.images.present?
			if guest.images.first.image_file_file_name == ""
				false
			else
				true
			end
		end
	end
end
