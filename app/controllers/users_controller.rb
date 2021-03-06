class UsersController < ApplicationController

  #Before aftions for users controller. 
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy]

  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end
  
  def index #Display all users.
    @users = User.paginate(page: params[:page])
  end
  
  def index_teacher #Display all users.
    @users = User.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      if @user.teacher
        flash[:success] = "Welcome to Mika Music! Add some Availabilities to get Started!"
        redirect_to(my_availabilities_path)
      else
        flash[:success] = "Welcome to Mika Music!"
        redirect_to @user
      end
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update.
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  def make_admin
    User.find(params[:id]).m_admin
    flash[:success] = "User promoted to admin"
    redirect_to users_url
  end
  
  private
  #Private functions for the users controller. 
  
    def user_params
      params.require(:user).permit(:name, :last_name, :dob, :email, :gender, :password, :facebook_ID,
                                   :password_confirmation, :teacher, :parent_name, :parent_email, :teacher_qualifications)
    end
    
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end