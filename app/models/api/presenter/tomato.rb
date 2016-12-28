module Api
  module Presenter
    class Tomato
      def initialize(tomato)
        @tomato = tomato
      end

      def as_json(_options = {})
        {
          id: @tomato.id.to_s,
          created_at: @tomato.created_at,
          updated_at: @tomato.updated_at,
          tags: @tomato.tags || []
        }
      end
    end
  end
end
