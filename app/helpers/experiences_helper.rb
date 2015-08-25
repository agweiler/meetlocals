module ExperiencesHelper
	def check_images(id)
		
	 	exp = Experience.find id
	 	if exp.exp_images.present?
		 	array = []
		 	exp.exp_images.each do |x|
		 		array << x.finished
		 	end
		 	puts "*********************" 
		 	puts array
		 	puts "*********************"
		 	if array.include?(nil)
		 		return false
		 	else 
		 		return true
		 	end
		end
	end
end
