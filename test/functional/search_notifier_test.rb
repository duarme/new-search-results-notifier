require 'test_helper'

class SearchNotifierTest < ActionMailer::TestCase
  test "new_search_results_for" do
    mail = SearchNotifier.new_search_results_for
    assert_equal "New search results for", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
