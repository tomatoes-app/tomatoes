module Api
  module Presenter
    class Tomatoes
      def initialize(tomatoes)
        @tomatoes = tomatoes
      end

      def as_json(_options = {})
        {
          tomatoes: @tomatoes.map(&Api::Presenter::Tomato.method(:new)),
          pagination: {
            current_page: @tomatoes.current_page,
            total_pages: @tomatoes.total_pages,
            total_count: @tomatoes.total_count
          }
        }
      end
    end
  end
end
