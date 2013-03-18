require 'config/boot'
require 'config/environment'
require 'clockwork'
include Clockwork

handler do |job|
  puts "Running #{job}"
end

every(1.hour, 'sync.files') { Delayed::Job.enqueue FileSyncJob.new(17)}