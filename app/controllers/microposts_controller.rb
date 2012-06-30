class MicropostsController < ApplicationController
#  before_filter :authenticate
#  before_filter :authorized_user, :only => :destroy
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :current_user, only: :destroy

  def index
    @user = User.find(params[:user_id])
    @microposts = @user.microposts.all.paginate(:page => params[:page])
  end

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_path
  end

  private

  def authorized_user
    @micropost = Micropost.find(params[:id])
    redirect_to root_path unless current_user?(@micropost.user)
  end

  def correct_user
    @micropost = current_user.microposts.find_by_id(params[:id])
    redirect_to root_path if @micropost.nil?
  end
end
