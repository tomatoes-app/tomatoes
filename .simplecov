require 'coveralls'

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start 'rails' do
  minimum_coverage(91.65)
  add_group 'Operations', 'app/operations'
end
