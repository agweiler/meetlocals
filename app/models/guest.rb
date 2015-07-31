class Guest < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,  :confirmable, :async,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :bookings
  has_many :images, as: :imageable
  has_many :notifications

  has_many :authentications, dependent: :destroy
  devise :omniauthable, :omniauth_providers => [:facebook]
  # removed uniqueness constraint
  # validates_uniqueness_of :username

  def all_notifications
    self.notifications.all
  end

  def apply_omniauth(omniauth)
    self.email = omniauth['info']['email'] if email.blank?
    puts "******************************"
    puts omniauth['info']
    puts "******************************"
    authentications.build(provider:omniauth['provider'], uid:omniauth['uid'])
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
end
