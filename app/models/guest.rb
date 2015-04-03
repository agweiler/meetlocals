class Guest < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,  :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :bookings
  has_many :images, as: :imageable
  # removed uniqueness constraint
  # validates_uniqueness_of :username
end
