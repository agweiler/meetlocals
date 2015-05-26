class Adminmailer < ApplicationMailer
	def host_created(host_id)
		@host = Host.find host_id
		@admin = Admin.find 1
		mail(to: @admin.email, subject: "A new host has been created!")
	end
end