class TagsController < ResourceController
  before_filter :authenticate_user!

  def index
    @tomatoes_by_tag = Rails.cache.fetch("tomatoes_by_tag_#{current_user.id}", expires_in: 1.day) do
      Tomato.by_tags(current_user.tomatoes)
    end

    @tomatoes_by_tag = Kaminari.paginate_array(@tomatoes_by_tag).page(params[:page])
  end

  def show
    @tag = params[:id]
    @tomatoes = current_user.tomatoes_by_tags([@tag])
  end
end
