class SearchNotifier < ActionMailer::Base
  default from: "from@example.com"

  def new_search_results_for(user)
    @user = user   
    @new_result_sets = new_result_sets_for(@user.searches)
    
    touch_notified_at_for(@new_result_sets) # PERFORMANCE maybe improvable moving this in an after callback
       
    mail to: @user.email, subject:  "[SEARCH_NOTIFIER] There are #{new_results_count} new results for " + 
                                    "#{@new_result_sets.size} of your preferred Searches"
  end
  handle_asynchronously :new_search_results_for, queue: 'users-preferred-searches-new-results-newsletter'
  
  private
  
  
  # Returns a hash with searches as keys and their new_results as values
  # see Search#new_results 
  def new_result_sets_for(searches)
    new_result_sets = Hash.new
    searches.each do |s|
        new_result_sets[s] = s.new_results if s.new_results.count > 0 
    end
    return new_result_sets
  end  
  
  def new_results_count
    @new_result_sets.any? ? @new_result_sets.map{|s, r| r.count}.inject(:+) : "no"
  end
  
  def touch_notified_at_for(result_set)
    # PERFORMANCE improvable via single SQL update query just after this block
    result_set.each_key {|s| s.touch(:notified_at) }      
  end
  
end
