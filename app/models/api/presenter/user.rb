module Api
  module Presenter
    class User
      def initialize(user)
        @user = user
      end

      def as_json(options = {})
        {
          id: @user.id.to_s,
          name: @user.name,
          email: @user.email,
          image: @user.image_file,
          time_zone: @user.time_zone,
          color: @user.color,
          volume: @user.volume,
          ticking: @user.ticking,
          work_hours_per_day: @user.work_hours_per_day,
          average_hourly_rate: @user.average_hourly_rate,
          currency: @user.currency,
          currency_unit: @user.currency_unit,
          tomatoes_counters: @user.tomatoes_counters,
          authorizations: authorizations,
          created_at: @user.created_at,
          updated_at: @user.updated_at
        }
      end

      private

      def authorizations
        @user.authorizations.select { |auth| auth.provider != 'tomatoes' }.map do |auth|
          {
            provider: auth.provider,
            uid: auth.uid,
            nickname: auth.nickname,
            image: auth.image
          }
        end
      end
    end
  end
end
