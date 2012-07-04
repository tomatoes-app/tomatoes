class UsersController < ResourceController
  before_filter :authenticate_user!, :except => :show
  before_filter :same_user!, :except => :show
  
  # GET /users/1/edit
  def edit
  end
  
  # PUT /users/1
  # PUT /users/1.xml
  def update
    update_resource(@user)
  end
  
  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    
    logger.debug "same_user?: #{same_user?.inspect}"

    if same_user?
      @tags = Rails.cache.fetch("tomatoes_by_tag_#{@user.id}", :expires_in => 1.day) do
        Tomato.by_tags(@user.tomatoes)
      end

      @tags = Kaminari.paginate_array(@tags).page(params[:page])
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    destroy_resource(@user, root_url)
  end
end
