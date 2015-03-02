class MessagesController < ApplicationController
	#POST/message/create
	def create
		@recipient = Host.find(params[:host])
		current_host.send_message(@recipient, params[:body], params[:subject])
		flash[:notice] = "Message has been sent!"
		redirect_to :conversation
	end
end
