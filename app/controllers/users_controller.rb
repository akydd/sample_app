class UsersController < ApplicationController
  # Filters are applied in order of appearance!
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers, :messages_to, :messages_from]
  before_filter :correct_user, only: [:edit, :update, :messages_to, :messages_from]
  before_filter :admin_user, only: :destroy
  before_filter :admin_cannot_delete_self, only: :destroy
  before_filter :not_for_authenticated_users, only: [:new, :create]

  def index
    @users = User.search(params[:search], params[:page])
    if @users.empty?
      flash.now[:error] = "No users found."
    end
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def messages_to
    @title = "Received Messages"
    @user = User.find(params[:id])
    @messages = @user.received_messages.paginate(page: params[:page])
    render 'show_messages'
  end

  def messages_from
    @title = "Sent Messages"
    @user = User.find(params[:id])
    @messages = @user.sent_messages.paginate(page: params[:page])
    render 'show_messages'
  end

  private

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def not_for_authenticated_users
    if signed_in?
      redirect_to root_path
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_cannot_delete_self
    @user = User.find(params[:id])
    if @user.admin? and current_user?(@user)
      redirect_to users_path, notice: "Admin user cannot delete self!"
    end
  end

end
