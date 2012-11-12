# == Schema Information
#
# Table name: searches
#
#  id                              :integer          not null, primary key
#  keywords                        :string(255)
#  category_id                     :integer
#  min_price                       :decimal(, )
#  max_price                       :decimal(, )
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  user_id                         :integer          not null
#  saved                           :boolean          default(FALSE), not null
#  notify                          :boolean          default(FALSE), not null
#  notified_at                     :datetime
#  new_results_presence            :boolean          default(FALSE)
#  new_results_presence_checked_at :datetime
#

class Search < ActiveRecord::Base
  
  belongs_to :user
  
  # class methods
  class << self
    def clear_unsaved
      Search.where(saved: false).destroy_all
    end
    handle_asynchronously :clear_unsaved, queue: 'searches-clear-unsaved' 
    
    def check_new_results_presence
      searches = Search.where(notify: true).where(new_results_presence: false).order(:new_results_presence_checked_at).limit(CONFIG[:number_of_searches_to_be_checked_for_new_results])
      searches.each {|s| s.new_results?}
    end
    handle_asynchronously :clear_unsaved, queue: 'searches-check-new-results-presence'
    
    def notify_new_results_by_mail
      # fetch all users with searches to be notified 
      @searches = Search.select('DISTINCT searches.user_id').where(new_results: true).order(:notified_at).limit(CONFIG[:max_daily_emails])
      @searches.reject_if! {|s| s.find_new_products < 1}
      # order user searches by notified_at
      # order users by their last notified search 
      # notify 200 user
    end
    handle_asynchronously :notify 
  end
  
  # If a search is to be notified, then it aslo be saved
  def notify=(n)
    notify = n
    saved = true if notify 
  end 
  
  # If a search is deleted from preferred ones, than it cannot be notified anymore
  def saved=(s)
    saved = s
    notify = false if !saved 
  end   
  
  def products
    @products ||= find_products
  end 
  
  def new_results
    @new_results ||= find_new_results
  end 
  
  # returns wheter or not there are new results for this search 
  # and updates new_results_presence column accordingly
  def new_results?
    nrp = new_results > 0
    self.update_column(:new_results_presence, nrp) if self.new_results != nrp
    self.touch(:new_results_presence_checked_at)
    return nr  
  end

  
private

  def find_products
    products = Product.order(:name)
    products = products.where("name like ?", "%#{keywords}%") if keywords.present?
    products = products.where(category_id: category_id) if category_id.present?
    products = products.where("price >= ?", min_price) if min_price.present?
    products = products.where("price <= ?", max_price) if max_price.present?
    products
  end  
  
  def find_new_results
    # If a search has never been notified before, since notified_at is nil, 
    # the time_reference is the search updated_at attribute. 
    time_reference = self.notified_at ? self.notified_at : self.updated_at
    products.where("updated_at >= ?", time_reference)
  end
  
end
