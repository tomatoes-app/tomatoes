module Api
  module Presenter
    class Score
      def initialize(score)
        @score = score
      end

      def as_json(_options = {})
        {
          user: user_attributes,
          score: @score.score
        }
      end

      private

      def user_attributes
        {
          id: @score.user.try(:id).try(:to_s),
          name: @score.user.try(:name),
          image: @score.user.try(:image_file)
        }
      end
    end
  end
end
