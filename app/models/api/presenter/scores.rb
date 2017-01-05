module Api
  module Presenter
    class Scores
      def initialize(scores)
        @scores = scores
      end

      def as_json(_options = {})
        {
          scores: @scores.map(&Api::Presenter::Score.method(:new)),
          pagination: {
            current_page: @scores.current_page,
            total_pages: @scores.total_pages,
            total_count: @scores.total_count
          }
        }
      end
    end
  end
end
