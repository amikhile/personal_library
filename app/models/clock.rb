require_relative '../../config/boot'
require_relative '../../config/environment'
require 'clockwork'

include Clockwork

handler do |job|
  puts "Running #{job}"
end

every(1.hour, 'sync.files') { Delayed::Job.enqueue FileSyncJob.new(17)}