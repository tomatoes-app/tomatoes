class UsersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :same_user!, except: :show

  # GET /users/1/edit
  def edit
  end

  # PUT /users/1
  def update
    if @user.update_attributes(resource_params)
      redirect_to @user, notice: 'User was successfully updated'
    else
      render action: 'edit'
    end
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to root_url
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
      :ticking
    )
  end
end
