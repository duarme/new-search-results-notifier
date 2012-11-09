# == Schema Information
#
# Table name: searches
#
#  id          :integer          not null, primary key
#  keywords    :string(255)
#  category_id :integer
#  min_price   :decimal(, )
#  max_price   :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          not null
#  saved       :boolean          default(FALSE), not null
#  notified    :boolean          default(FALSE), not null
#  notified_at :datetime
#

class Search < ActiveRecord::Base
  
  belongs_to :user
  
  def products
    @products ||= find_products
  end 
  
  def new_results
    @new_results ||= find_new_results
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
    time_reference = self.notified_at ? self.notified_at : self.updated_at
    products.where("updated_at >= ?", time_reference)
  end
  
end
