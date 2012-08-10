require 'logger'
#log = Logger.new(STDOUT)
log = Logger.new("Application.log", 5, 10 * 1024)
#log.level = Logger::INFO
log.level = Logger::DEBUG
log.datetime_format = "%H:%M:%S"
log.info("Application Starting")
temperature = 45

4.times do |i|
  log.debug("Excuting loop, i = #{i}")
  log.warn("Possible overheat, i = #{i}") if temperature > 50
  temperature += 5
end

log.info("Application Terminating")
