require 'test_helper'

class TomatoesHelperTest < ActionView::TestCase
  test 'tomato_duration should return a formatted string' do
    @created_at = Time.mktime(2011, 7, 24, 15, 10).utc
    @ended_at = @created_at - Tomato::DURATION
    @tomato = Tomato.new(created_at: @created_at)

    assert tomato_duration(@tomato) == "#{@ended_at.strftime('%I:%M %p')} - #{@created_at.strftime('%I:%M %p')}"
  end
end
