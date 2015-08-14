class Host < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :experiences, dependent: :destroy
  has_many :images, as: :imageable
  has_many :notifications
  has_many :bookings, dependent: :destroy
  has_many :bookings, through: :experiences
  has_many :testimonials, dependent: :destroy
  has_many :testimonials, through: :bookings
  has_many :holidays

  scope :in_holiday,
   -> (date) { joins(:holidays).where("holidays.date = ?", date) }

  scope :has_booking,
   -> (date) { joins(:bookings).where("bookings.date = ? AND status = 'confirmed'", date) }
  # scope :not_holiday,
  #  -> (date) { joins(:holidays).where("holidays.date <> ?", date) }
  scope :from_state, -> (location) { where("state = ?", location) }

  # removed uniqueness constraint
  # validates_uniqueness_of :username - not needed because of devise validatable

  def email_to_username
  	email.gsub(/@.*/, "").capitalize
  end

  def self.age_ranges
    ['Age', '20-35', '36-50', '51-65', '66+']
  end

  # def self.search_by_age(low, high) # 20, 35
  #   high ||= 200
  #   young = Date.today.year - low.to_i #20 -> 1995
  #   old = Date.today.year - high.to_i #35 -> 1980
  #
  #   lower_range = Date.new(  old, 01, 01 ) #1980.1.1
  #   upper_range = Date.new(young, 12, 31 ) #1995.12.31
  #
  #   # between [ >=] 1980.1.1 and [<= ] 1995.12.31
  #   Host.where('dob >= ? AND dob <= ?', lower_range, upper_range)
  # end

  # def self.search(low, high, loc) #low_age, high_age, location
  #   high ||= 200
  #   young = Date.today.year - low.to_i #20 -> 1995
  #   old = Date.today.year - high.to_i #35 -> 1980
  #
  #   lower_range = Date.new(  old, 01, 01 ) #1980.1.1
  #   upper_range = Date.new(young, 12, 31 ) #1995.12.31
  #
  #   loc == "All" ? loc = '' : loc = "AND state = '#{loc}'"
  #
  #   # between [ >=] 1980.1.1 and [<= ] 1995.12.31
  #   # Host.where('dob >= ? AND dob <= ? ?', lower_range, upper_range, loc)
  #   sql = "dob >= '#{lower_range}' AND dob <= '#{upper_range}' " + loc
  #   Host.where(sql)
  # end

  def self.search(low, high, loc, group, date) #low_age, high_age, etc..
    high ||= 200 #66+
    young = Date.today.year - low.to_i #20 -> 1995
    old = Date.today.year - high.to_i #35 -> 1980

    lower_range = Date.new(  old, 01, 01 ) #1980.1.1
    upper_range = Date.new(young, 12, 31 ) #1995.12.31
    age = "dob >= '#{lower_range}' AND dob <= '#{upper_range}'"

    loc == "Location" ? loc = '' : loc = " AND state = '#{loc}'"
    group == "Guests" ? group = "" : group = " AND experiences.max_group_size >= #{group} AND experiences.date IS NULL"

    # between [ >=] 1980.1.1 and [<= ] 1995.12.31
    # Host.where('dob >= ? AND dob <= ? ?', lower_range, upper_range, loc)

    # Host.joins(:experiences).where(age + loc + group).uniq.map do |host|
    #   host if host.free?(date.to_date)
    # end.compact
    if date.blank?
      # Host.joins(:experiences).where(age + loc + group).uniq
      host_in = " AND hosts.id IN(#{Experience.pluck('host_id').uniq.join(',')})"
    else
      # Host.joins(:experiences).where(age + loc + group).not_holiday(date).uniq
      free_hosts = Experience.pluck('host_id').uniq -
                    Host.in_holiday(date).pluck('hosts.id').uniq -
                    Host.has_booking(date).pluck('hosts.id').uniq

      # host_in = " AND id IN(#{free_hosts.join(',')})"
      host_in = " AND hosts.id IN(#{free_hosts.join(',')})"
    end

    # Host.where( age + loc + group + host_in ).order('random()')
    # removed random here
    Host.joins(:experiences).where(age + loc + host_in + group).uniq
  end

  def age
    # now = Time.now.utc.to_date
    # dob = self.dob
    # return nil if dob.nil?
    # now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
    Date.today.year - dob.year unless dob.nil?
  end

  def free?(date)
    !(self.holidays.find_by(date:date) || self.bookings.find_by(date:date, status:'confirmed'))
  end

  # def max_group_size
  #   self.experiences.maximum(:max_group_size)
  # end

  def self.get_location
  	# ["Region","Zeeland", "Nordjylland", "Midtjylland","Syddanmark", "Hovedstaden"]
		[['Location','Location'],
		 ['West region','Zeeland'],
		 ['North region', 'Nordjylland'],
		 ['Center region', 'Midtjylland'],
		 ['South & Fyn', 'Syddanmark'],
		 ['Copenhagen', 'Hovedstaden']]
	end

  def location
    hash = {'Zeeland' => 'West region',
    'Nordjylland' => 'North region',
    'Midtjylland' => 'Center region',
    'Syddanmark' => 'South & Fyn',
    'Hovedstaden' => 'Copenhagen'}

    x = [self.suburb, hash[self.state], self.country].reject do |itm|
      itm.nil? || itm.empty?
     end.join(', ')
  end

  def avg_rating
    self.testimonials.average(:rating).round(2)
  end

  def holidays_list
    # self.holidays.map { |holiday| holiday.date.strftime('%D') } # 05/19/15
    self.holidays.map { |holiday| holiday.date.strftime('%F') } # 2015-05-19
  end

  def smoker?
    if self.smoker == true
      return "Smoker"
    else
      nil
    end
  end

  def host_approved?
    self.approved
  end

  def set_holiday(dates)
    self.holidays.destroy_all
    return true if dates.blank?

    dates.split(',').each do |date|
      holiday = self.holidays.new(date:date.strip)
      holiday.save
    end
    true
  end

  def all_notifications
    self.notifications.all
  end

  def next_host_party
    self.experiences.special_events.each do |x|
      if x.date > Time.now
        return x
      end
    end
    return self.experiences.special_events[0].id

  end
end
