class Booking < ActiveRecord::Base
	belongs_to :guest
	belongs_to :experience
	has_one :testimonial
	has_many :messages

	validates :guest_id, :experience_id, :date, presence: true
	validate :group_size_must_not_exceed_maximum

	scope :confirmed, -> { where(status: 'confirmed') }

	def group_size_must_not_exceed_maximum
		max = self.experience.max_group_size
		unless (max >= 0 && max == nil)
			if self.group_size > self.experience.max_group_size
				errors.add(:group_size, "cannot exceed maximum (#{max} people)")
			end
		end
	end

	def self.update_status(status)
		case status.downcase
		# when "Requested" #default
		when "invite"
			status.replace("invited")
		when "reject"
			status.replace("rejected")
		when "confirm"
			status.replace("confirmed")
		when "complete"
			status.replace("completed")
		end
		status
	end

	def mark_as_complete
		status.replace("completed")
		@guest = self.guest
		@booking_id = self.id
		Guestmailer.experience_completed(@booking_id, @guest.id).deliver_now
		save
	end

	def check_finished?
		#Settle!
				Time.now >= self.date && Time.now.hour > (self.experience.time.hour + 4.hours)
	end

#Here we need to make this trigger the booking status as complete, rather than render a "complete" button.

	def self.statuses
		["Invite", "Reject", "Complete"]
	end

	def self.confirmed_dates
		self.confirmed.map { |book| book.date.strftime('%F') }
	end

	# DO STUFF HERE MON
	serialize :notification_params, Hash
	def paypal_url(return_path)
		@experience = Experience.find(self.experience_id)
		@api = PayPal::SDK::AdaptivePayments.new
		# Build request object
		@pay = @api.build_pay({
	  	:actionType => "PAY",
	  	:cancelUrl => "http://gentle-inlet-1053.herokuapp.com/",
	  	:currencyCode => "DKK",
	  	:ipnNotificationUrl => "#{Rails.application.secrets.app_host}/hook",
	  	:receiverList => {
	    	:receiver => [{
	      	:amount => @experience.price,
	      	:email => "Meetdanes@meetdanes.com",
	      	:invoiceId => "#{id}" + (0...8).map { (65 + rand(26)).chr }.join 
	      	}],
	      },
	  	  :returnUrl => "#{Rails.application.secrets.app_host}/#{return_path}" 
	  	})
		# values = {
	#     business: "thenasiproject-facilitator@gmail.com ",
	#     cmd: "_xclick",
	#     upload: 1,
	#     return: "#{Rails.application.secrets.app_host}#{return_path}",
	#     invoice: "#{id}" + (0...8).map { (65 + rand(26)).chr }.join,
	#     amount: @experience.price,
	#     item_name: "#{@experience.title} experience booking",
	#     item_number: @experience.id,
	#     quantity: self.group_size,
	#     notify_url: "#{Rails.application.secrets.app_host}/hook"
	# }
		@response = @api.pay(@pay)
	  if @response.success? && @response.payment_exec_status != "ERROR"
	    # @api.payment_url(@response)  # Url to complete payment
	    "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_ap-payment&paykey=" + @response.payKey
	  else
	    @response.error[0].message
	  end
	end

	def paypal_refund(receiver)
		@api = PayPal::SDK::AdaptivePayments::API.new

		# Build request object
		@refund = @api.build_refund({
		  :currencyCode => "DKK",
		  :transactionId => @booking.transaction_id,
		  :receiverList => {
		    :receiver => [{
		      :amount => @booking.experience.price,
		      :email => receiver }] } })

		# Make API call & get response
		@refund_response = @api.refund(@refund)

		# Access Response
		if @refund_response.success?
		  @refund_response.currencyCode
		  @refund_response.refundInfoList
		else
		  @refund_response.error
		end
	end
end
