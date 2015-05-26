class Holiday < ActiveRecord::Base
  belongs_to :host
  # validates :date, uniqueness: false
end
