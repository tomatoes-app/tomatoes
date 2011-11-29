require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "relative_day should return the string 'Today' if date is the current day" do
    pending
    
    assert true
  end
  
  test "relative_day should return the string 'Yesterday' if date is the day before the current day" do
    pending
    
    assert true
  end
  
  test "relative_day should return the string a formatted date if it's not today or yesterday" do
    pending
    
    assert true
  end
  
  [
    {:secs => 30, :string => '30 seconds'},
    {:secs => 60 + 1, :string => '1 minute, 1 second'},
    {:secs => 60*2 + 1, :string => '2 minutes, 1 second'},
    {:secs => 60*60*2 + 60*2 + 1, :string => '2 hours, 2 minutes, 1 second'},
    {:secs => 24*60*60*2 + 60*60*2 + 60*2 + 1, :string => '2 days, 2 hours, 2 minutes, 1 second'},
    {:secs => 365*24*60*60*2 + 24*60*60*2 + 60*60*2 + 60*2 + 1, :string => '2 years, 2 days, 2 hours, 2 minutes, 1 second'}
  ].each do |data|
    test "humanize #{data[:secs]} secs returns '#{data[:string]}'" do
      assert humanize(data[:secs]) == data[:string]
    end
  end
end
