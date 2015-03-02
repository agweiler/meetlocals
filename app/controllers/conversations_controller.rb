class ConversationsController < ApplicationController
	before_action :authenticate_host!
	
	helper_method :mailbox, :conversation

	def index
		@conversations ||= current_host.mailbox.inbox.all
	end

	def reply
		current_user.reply_to_conversation(conversation, *message_params(:body, :subject))
		redirect_to_conversation
	end

	def trashbin
		@trash ||= current_host.mailbox.trash.all
	end

	def trash 
		conversation.move_to_trash(current_host)
	end

	def empty_trash
		current_host.mailbox.trash.each do |conversation|
			conversation.receipts_for(current_host).update_all(:deleted => true)
		end
	end

	private

	def mailbox
		@mailbox ||= current_host.mailbox
	end

	def conversation 
		@conversation ||= mailbox.conversations.find(params[:id])
	end

	def conversation_params(*keys)
		fetch_params(:conversation, *keys)
	end

	def message_params(*keys)
		fetch_params(:message, *keys)
	end

	def fetch_params(key, *subkeys)
		params[key].instance_eval do
			case subkeys.size
			when 0 then self
			when 1 then self[subkeys.first]
			else subkeys.map{|k| self [k]}
			end
		end
	end
end
