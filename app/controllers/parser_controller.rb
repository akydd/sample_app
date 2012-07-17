class ParserController < ApplicationController

  before_filter :signed_in_user, only: [:create]

# def create
    # transform params to fit micropost
#    micropost_params = {'content' => params[:command]}
#    @micropost = current_user.microposts.build(micropost_params)
#    if @micropost.save
#      flash[:success] = "Micropost created!"
#      redirect_to root_path
#    else
#      @feed_items = []
#      if @micropost.errors.empty?
#        flash.now[:error] = "Unknown error"
#      else
#        @micropost.errors.full_messages.each do |err|
#          flash.now[:error] = err
#        end
#      end
#      render 'static_pages/home'
#    end
#  end

  def create
    invoker = CommandInvoker.new(current_user)
    invoker.command = params[:command]
    if invoker.execute
      flash[:success] = invoker.success_message
      redirect_to root_path
    else
      @feed_items = []
      if invoker.errors.empty?
        flash.now[:error] = "Unknown error"
      else
        invoker.errors.full_messages.each do |err|
          flash.now[:error] = err
        end
      end
      render 'static_pages/home'
    end
  end

end
