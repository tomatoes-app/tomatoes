class TomatoesController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /tomatoes
  # GET /tomatoes.xml
  def index
    @tomatoes = current_user.tomatoes.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tomatoes }
    end
  end

  # GET /tomatoes/1
  # GET /tomatoes/1.xml
  def show
    @tomato = current_user.tomatoes.find(params[:id])

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
    @tomato = current_user.tomatoes.find(params[:id])
  end

  # POST /tomatoes
  # POST /tomatoes.xml
  def create
    @tomato = current_user.tomatoes.build(params[:tomato])

    respond_to do |format|
      if @tomato.save
        format.html { redirect_to(@tomato, :notice => 'Tomato was successfully created.') }
        format.xml  { render :xml => @tomato, :status => :created, :location => @tomato }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tomato.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tomatoes/1
  # PUT /tomatoes/1.xml
  def update
    @tomato = current_user.tomatoes.find(params[:id])

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
    @tomato = current_user.tomatoes.find(params[:id])
    @tomato.destroy

    respond_to do |format|
      format.html { redirect_to(tomatoes_url) }
      format.xml  { head :ok }
    end
  end
end
