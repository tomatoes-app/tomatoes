require 'test_helper'

class RankingsHelperTest < ActionView::TestCase
  test "ranking_title should return the appropriate title based on the parameter" do
    assert ranking_title('all_time')   == "All time top tomatoers"
    assert ranking_title('today')      == "Today's top tomatoers"
    assert ranking_title('this_week')  == "This week's top tomatoers"
    assert ranking_title('this_month') == "This month's top tomatoers"
  end
end
