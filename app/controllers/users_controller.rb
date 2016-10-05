class UsersController < ResourceController
  before_action :authenticate_user!, except: :show
  before_action :same_user!, except: :show

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

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @user }
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    destroy_resource(@user, root_url)
  end

  private

  def resource_params
    params.require(:user).permit(
      :name,
      :email,
      :image,
      :time_zone,
      :color,
      :work_hours_per_day,
      :average_hourly_rate,
      :currency,
      :volume,
      :ticking)
  end
end
