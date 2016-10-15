require 'rdiscount'

module MarkdownHandler
  class << self
    def erb
      @erb ||= ActionView::Template.registered_template_handler(:erb)
    end

    def call(template)
      compiled_source = erb.call(template)
      "RDiscount.new(begin;#{compiled_source};end).to_html"
    end
  end
end

ActionView::Template.register_template_handler :md, MarkdownHandler
