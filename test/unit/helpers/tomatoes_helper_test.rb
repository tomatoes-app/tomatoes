require 'test_helper'

class TomatoesHelperTest < ActionView::TestCase
  test "tomato_duration should return a formatted string" do
    @created_at = Time.mktime(2011, 7, 24, 15, 10)
    @tomato = Tomato.new(:created_at => @created_at)
    
    assert tomato_duration(@tomato) == "02:45 PM - 03:10 PM"
  end
end
