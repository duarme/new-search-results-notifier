# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "#{path}/log/cron.log"

# Check searches for new results presence every hour
# limited by CONFIG[:number_of_searches_to_be_checked_for_new_results]
every :hour do
  runner "Search.check_new_results_presence"  
end

# Send new search results newsletters
# limited by CONFIG[:max_daily_emails]
every 1.day, :at => '00:01 am' do
  runner "Search.notify_new_results_by_mail"
end   

# Clear unsaved searches every first day of every month at 01:00
# NB: Search#clear_unsaved is handled by delayed_job 
every '0 1 1 * *' do
  runner "Search.clear_unsaved"
end

# Learn more: http://github.com/javan/whenever
