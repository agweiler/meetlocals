# Preview all emails at http://localhost:3000/rails/mailers/hostmailer
class HostmailerPreview < ActionMailer::Preview
	def payment_completion()

	  Hostmailer.payment_completion(1,2)
	end
end
