class TomatoesController < ApplicationController
  before_filter :authenticate_user!, :except => [:by_day, :by_hour]
  before_filter :find_user, :only => [:by_day, :by_hour]
  before_filter :find_tomato, :only => [:show, :edit, :update, :destroy]
  
  # GET /tomatoes
  # GET /tomatoes.xml
  # GET /tomatoes.csv
  # GET /users/1/tomatoes
  # GET /users/1/tomatoes.xml
  # GET /users/1/tomatoes.csv
  def index
    @tomatoes = current_user.tomatoes.order_by([[:created_at, :desc]]).page params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tomatoes }
      format.csv  { export_csv(current_user.tomatoes.order_by([[:created_at, :desc]])) }
    end
  end
  
  # GET /users/1/tomatoes/by_day.json
  def by_day
    respond_to do |format|
      format.json { render :json => Tomato.by_day(@user.tomatoes) }
    end
  end
  
  # GET /users/1/tomatoes/by_hour.json
  def by_hour
    respond_to do |format|
      format.json { render :json => Tomato.by_hour(@user.tomatoes) }
    end
  end

  # GET /tomatoes/1
  # GET /tomatoes/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tomato }
    end
  end

  # GET /tomatoes/new
  # GET /tomatoes/new.xml
  def new
    @tomato = current_user.tomatoes.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tomato }
    end
  end

  # GET /tomatoes/1/edit
  def edit
  end

  # POST /tomatoes
  # POST /tomatoes.js
  # POST /tomatoes.xml
  def create
    @tomato = current_user.tomatoes.build(params[:tomato])

    respond_to do |format|
      if @tomato.save
        format.js do
          @highlight = @tomato
          @tomatoes  = current_user.tomatoes_after(Time.zone.now.beginning_of_day)
          
          @long_break = true if 0 == @tomatoes.size % 4
          if @long_break
            flash.now[:notice] = "You just finished your #{ActiveSupport::Inflector::ordinalize(@tomatoes.size)} pomodoro, you deserve a long break!"
          else
            flash.now[:notice] = 'Pomodoro finished, tomato created, it\'s time for a break.'
          end
        end
        format.html { redirect_to(root_url, :notice => 'Tomato created, now it\'s time for a break.') }
        format.xml  { render :xml => @tomato, :status => :created, :location => @tomato }
      else
        # TODO: error format.js
        format.html { render :action => "new" }
        format.xml  { render :xml => @tomato.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tomatoes/1
  # PUT /tomatoes/1.xml
  def update
    respond_to do |format|
      if @tomato.update_attributes(params[:tomato])
        format.html { redirect_to(@tomato, :notice => 'Tomato was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tomato.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tomatoes/1
  # DELETE /tomatoes/1.xml
  def destroy
    @tomato.destroy

    respond_to do |format|
      format.html { redirect_to(tomatoes_url) }
      format.xml  { head :ok }
    end
  end

  protected

  def export_csv(tomatoes)
    filename = "my tomatoes #{I18n.l(Time.now)}.csv"
    content = Tomato.to_csv(tomatoes)
    send_data content, :filename => filename
  end

  def find_user
    @user = User.find(params[:user_id])
  end

  def find_tomato
    @tomato = current_user.tomatoes.find(params[:id])
  end
end
