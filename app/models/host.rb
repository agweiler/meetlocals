class Host < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :experiences
  has_many :images, as: :imageable

  has_many :bookings
  has_many :bookings, through: :experiences
  has_many :testimonials
  has_many :testimonials, through: :bookings
  # removed uniqueness constraint
  # validates_uniqueness_of :username - not needed because of devise validatable


  def email_to_username
  	email.gsub(/@.*/, "").capitalize
  end

  def self.age_ranges
    [' ', '20-35', '36-50', '51-65', '66+']
  end

  def self.search_by_age(low, high) # 20, 35
    high ||= 200
    young = Date.today.year - low.to_i #20 -> 1995
    old = Date.today.year - high.to_i #35 -> 1980

    lower_range = Date.new(  old, 01, 01 ) #1980.1.1
    upper_range = Date.new(young, 12, 31 ) #1995.12.31

    # between [ >=] 1980.1.1 and [<= ] 1995.12.31
    Host.where('dob >= ? AND dob <= ?', lower_range, upper_range)
  end

  def self.search(low, high, loc) #low_age, high_age, location
    high ||= 200
    young = Date.today.year - low.to_i #20 -> 1995
    old = Date.today.year - high.to_i #35 -> 1980

    lower_range = Date.new(  old, 01, 01 ) #1980.1.1
    upper_range = Date.new(young, 12, 31 ) #1995.12.31

    loc == "All" ? loc = '' : loc = "AND state = '#{loc}'"

    # between [ >=] 1980.1.1 and [<= ] 1995.12.31
    # Host.where('dob >= ? AND dob <= ? ?', lower_range, upper_range, loc)
    sql = "dob >= '#{lower_range}' AND dob <= '#{upper_range}' " + loc
    Host.where(sql)
  end

  def age
    now = Time.now.utc.to_date
    dob = self.dob
    return nil if dob.nil?
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

  def self.get_location
    ["All","Zeeland", "Nordjylland", "Midtjylland","Syddanmark", "Hovedstaden"]
  end

  def avg_rating
    self.testimonials.average(:rating).round(2)
  end
end
