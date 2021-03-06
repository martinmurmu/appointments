# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# Consumer User receives text every 72 hours (between 8A-8P) indicating they are
# on the waitlist, and asking if they want to remain on the list.

require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

set :environment, Rails.env
set :output, {:error => "log/cron_error.log", :standard => "log/cron_standard.log"}

every :day, :at => '4:00pm' do
  runner "Manager.notify_waitlists"
end

