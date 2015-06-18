class Notification < ActiveRecord::Base
	belongs_to :guest
	belongs_to :host

	def index
	end
end
