module ExperiencesHelper
	def check_images(id)
		 # waiting = Sidekiq::Queue.new
		 # working = Sidekiq::Workers.new
		 # pending = Sidekiq::ScheduledSet.new
		 # return false if pending.find { |job| job.jid == jid }
		 # return false if waiting.find { |job| job.jid == jid }
		 # return false if working.find { |process_id, thread_id, work| work["payload"]["jid"] == jid }
		 # true
		
	 	exp = Experience.find id
	 	if exp.images.present?
		 	array = []
		 	exp.images.each do |x|
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
