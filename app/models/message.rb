class Message < ActiveRecord::Base
  belongs_to :booking

  validates :text, presence: true
end
