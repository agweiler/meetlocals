PumaWorkerKiller.config do |config|
  config.ram           = 512 # mb
  config.frequency     = 20    # seconds
  config.percent_usage = 0.95
  config.rolling_restart_frequency = 24 * 3600 # 12 hours in seconds
end

PumaWorkerKiller.start