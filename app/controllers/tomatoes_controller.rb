class TomatoesController < ApplicationController
  include TomatoesParams

  before_action :authenticate_user!, except: [:by_day, :by_hour]
  before_action :find_user, only: [:by_day, :by_hour]
  before_action :find_tomato, only: [:show, :edit, :update, :destroy]

  # GET /tomatoes
  # GET /tomatoes.csv
  def index
    @tomatoes = current_user.tomatoes.order_by([[:created_at, :desc]]).page params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.csv { export_csv(current_user.tomatoes.order_by([[:created_at, :desc]])) }
    end
  end

  # GET /users/1/tomatoes/by_day.json
  def by_day
    respond_with_json do
      Rails.cache.fetch("tomatoes_by_day_user_#{@user.id}", expires_in: 1.hour) do
        Tomato.by_day(@user.tomatoes) do |tomatoes_by_day|
          tomatoes_by_day.try(:size).to_i
        end
      end
    end
  end

  # GET /users/1/tomatoes/by_hour.json
  def by_hour
    respond_with_json do
      Rails.cache.fetch("tomatoes_by_hour_user_#{@user.id}", expires_in: 1.day) do
        Tomato.by_hour(@user.tomatoes) do |tomatoes_by_hour|
          tomatoes_by_hour.try(:size).to_i
        end
      end
    end
  end

  # GET /tomatoes/1
  def show; end

  # GET /tomatoes/new
  def new
    @tomato = current_user.tomatoes.build
  end

  # GET /tomatoes/1/edit
  def edit; end

  # POST /tomatoes
  # POST /tomatoes.js
  def create
    @tomato = current_user.tomatoes.build(resource_params)

    respond_to do |format|
      if @tomato.save
        format.js do
          @highlight      = @tomato
          @tomatoes       = current_user.tomatoes.after(Time.zone.now.beginning_of_day).order_by([[:created_at, :desc]])
          @tomatoes_count = current_user.tomatoes_counters
          @projects       = @tomatoes.collect(&:projects).flatten.uniq

          define_break
          flash.now[:notice] = notice_message
        end
        format.html { redirect_to(root_url, notice: I18n.t('tomato.created')) }
      else
        # TODO: error format.js
        format.html { render action: 'new' }
      end
    end
  end

  # PUT /tomatoes/1
  def update
    if @tomato.update_attributes(resource_params)
      redirect_to @tomato, notice: I18n.t('tomato.updated')
    else
      render action: 'edit'
    end
  end

  # DELETE /tomatoes/1
  def destroy
    @tomato.destroy

    redirect_to tomatoes_url
  end

  protected

  def export_csv(tomatoes)
    filename = "my tomatoes #{I18n.l(Time.zone.now)}.csv"
    content = Tomato.to_csv(tomatoes)
    send_data content, filename: filename
  end

  def find_user
    @user = User.find(params[:user_id])
  end

  def find_tomato
    @tomato = current_user.tomatoes.find(params[:id])
  end

  def define_break
    @long_break = (@tomatoes.size % 4).zero?
  end

  def notice_message
    if @long_break
      I18n.t('tomato.long_break', ordinal_count: ActiveSupport::Inflector.ordinalize(@tomatoes.size))
    else
      I18n.t('tomato.short_break')
    end
  end
end
