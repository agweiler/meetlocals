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

	def status_action
		case self.status
		when "requested"
			host_msg = "<p><b>Congratulations!</b> You have just received a booking request from a potential guest.</br> Click 'Respond to request' to accept, reject or modify the request, or use the Chat interface to get more information.</p>"
			guest_msg = "<p><b>Well done!</b> You have now created a booking request. Your potential host will get back to you as soon as possible.</p>"
		when "invited"
			host_msg = "<p><b>Well done!</b> You have accepted a booking request by sending an invitation.</br> Please wait for the guest to confirm booking. You will receive a notification by email.</p>"
			guest_msg = "<p><b>Congratulations!</b> The host has accepted your booking request. Please complete payment by clicking 'Pay with Paypal'.</p>"
		when "rejected"
			host_msg = "<p><b>Oh no!</b> Unfortunately you had to reject this booking request.</p>"
			guest_msg = "<p><b>Oh no!</b> Unfortunately the host had to reject this booking request.</p>"
		when "confirmed"
			host_msg = "<p><b>Congratulations!</b> A guest has confirmed the booking by completing payment to Meet The Danes.</br> Please do not forget to click 'Mark as COMPLETE' to initiate funds transfer once the event is complete.</br>Also note that booking status updates may require a moment to take effect.
 </p>"
			guest_msg = "<p><b>Well done!</b> You have confirmed your booking by completing payment.</br>Please note that booking status updates may require a moment to take effect.</br> Have an excellent experience meeting the danes!</p>"
		when "completed"
			host_msg = "<p><b>Congratulations!</b> You have successfully hosted a group of guests. The funds earned from the event will be transferred in the next payment cycle.</p>"
			guest_msg = "<p><b>Congratulations!</b> You have officially finished meeting some danes. Make sure to enjoy the rest of your trip!</p>"
		end

		return { Host: host_msg, Guest: guest_msg }
	end

	def mark_as_complete
		status.replace("completed")
		@guest = self.guest
		@booking_id = self.id
		host_id = self.experience.host_id
		Guestmailer.experience_completed(@booking_id, @guest.id).deliver_later
		Adminmailer.experience_completed(host_id, @guest.id).deliver_later
		save
	end

	def check_finished?

			time_in_seconds = Time.parse(self.experience.time.strftime("%I:%M:%S %p")).seconds_since_midnight.seconds
			date = self.date.to_datetime
			date_today = date + time_in_seconds
			if Time.now > date_today
				true
			else
				false
			end

	end

#Here we need to make this trigger the booking status as complete, rather than render a "complete" button.

	def self.statuses
		["Invite", "Reject"]
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
	      	:amount => (@experience.price * self.group_size * 1.019 + 2.60).round(2) ,
	      	:email => "Meetdanes@meetdanes.com",
	      	:invoiceId => "#{id}" + (0...8).map { (65 + rand(26)).chr }.join
	      	}],
	      },
	  	  :returnUrl => "#{Rails.application.secrets.app_host}#{return_path}"
	  	})
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
