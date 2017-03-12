require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  [
    {
      time: 30.seconds,
      string: '30 seconds'
    },
    {
      time: 1.minute + 1.second,
      string: '1 minute, 1 second'
    },
    {
      time: 2.minutes + 1.second,
      string: '2 minutes, 1 second'
    },
    {
      time: 2.hours + 2.minutes + 1.second,
      string: '2 hours, 2 minutes, 1 second'
    },
    {
      time: 2.days + 2.hours + 2.minutes + 1.second,
      string: '2 days, 2 hours, 2 minutes, 1 second'
    },
    {
      time: (2 * 365).days + 2.days + 2.hours + 2.minutes + 1.second,
      string: '2 years, 2 days, 2 hours, 2 minutes, 1 second'
    }
  ].each do |data|
    test "humanize #{data[:time]} secs returns '#{data[:string]}'" do
      assert_equal(data[:string], humanize(data[:time]))
    end
  end
end
