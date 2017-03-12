module LeaderboardController
  extend ActiveSupport::Concern

  included do
    before_action :find_scores, only: :show
  end

  def show; end

  def find_scores
    @scores = scope.includes(:user).desc(:score).page(params[:page])
  end
end
