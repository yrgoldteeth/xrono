class UsersController < ApplicationController
  before_filter :load_user, :only => [:show, :edit, :change_password, :historical_time, :update]

  access_control do
    allow :admin
    allow :developer, :to => [:edit, :change_password], :if => :user_is_current_user?
    allow :developer, :to => [:index, :show, :historical_time]
    allow :client, :to => [:edit, :change_password], :if => :user_is_current_user?
    allow :client, :to => [:index, :show, :historical_time]
  end

  def index
    @users = User.unlocked.sort_by_name
  end

  def show
  end

  def edit
  end

  def change_password
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice] = t(:password_updated_successfully)
      redirect_to :action => :show
    else
      params[:user][:password] = params[:user][:password_confirmation] = ''
      flash.now[:error] = t(:password_updated_unsuccessfully)
      render :action => :edit
    end
  end

  def historical_time
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = t(:user_updated_successfully)
      redirect_to @user
    else
      flash.now[:error] = t(:user_updated_unsuccessfully)
      render :action => 'edit'
    end
  end

  private

    def load_user
      @user = User.find(params[:id])
    end

    def user_is_current_user?
      @user == current_user
    end

end
