
if defined?(ActionMailer)
  class Devise::Mailer < Devise.parent_mailer.constantize
    include Devise::Mailers::Helpers

    def confirmation_instructions(record, token, opts={})
    	if record.class == Host
    		@commision = Admin.first.commision_percentage
    		byebug
    	end
      @token = token
      devise_mail(record, :confirmation_instructions, opts)
    end
  end
end
