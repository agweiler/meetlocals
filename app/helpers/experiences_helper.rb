module ExperiencesHelper
	 def check_images(id)
	 	exp = Experience.find id
	 	array = []
	 	exp.images.each do |x|
	 		array << x.image_file_file_name.to_s
	 	end
	 	if array.count == 3
	 		return true
	 	else 
	 		return false
	 	end
	end
end
