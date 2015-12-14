class Guest < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,  :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :bookings, dependent: :destroy
  has_many :images, as: :imageable
  has_many :notifications, dependent: :destroy

  has_many :authentications, dependent: :destroy
  devise :omniauthable, :omniauth_providers => [:facebook]
  # removed uniqueness constraint
  # validates_uniqueness_of :username

  def all_notifications
    self.notifications.all
  end

  # def number_of_guests
  #   self.no_of_adults + self.no_of_children
  # end

  def apply_omniauth(omniauth)
    self.email = omniauth['info']['email'] if email.blank?
    self.username = omniauth['info']['name'] if username.blank?
    puts "******************************"
    puts omniauth
    puts "******************************"
    authentications.build(provider:omniauth['provider'], uid:omniauth['uid'])
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
end
