module BookingsHelper

	def host_was_paid?(paid)
		if paid == true
			"Yes"
		else
			"No"
		end
	end
end
