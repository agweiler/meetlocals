if ENV["REDISTOGO_URL"] != nil
	uri = URI.parse(ENV["REDISTOGO_URL"])
	REDIS = Redis.new(:url => uri)
end

