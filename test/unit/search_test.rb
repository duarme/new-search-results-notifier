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
#  notify      :boolean          default(FALSE), not null
#  notified_at :datetime
#

require 'test_helper'

class SearchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
