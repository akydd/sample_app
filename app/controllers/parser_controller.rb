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
    command = Parser.new(params[:command], current_user).command
    if command.execute
      flash[:success] = command.success_message
      redirect_to root_path
    else
      @feed_items = []
      if command.errors.empty?
        flash.now[:error] = "Unknown error"
      else
        command.errors.full_messages.each do |err|
          flash.now[:error] = err
        end
      end
      render 'static_pages/home'
    end
  end

end
