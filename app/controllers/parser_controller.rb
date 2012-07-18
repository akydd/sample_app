class ParserController < ApplicationController

  before_filter :signed_in_user, only: [:create]

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
        invoker.errors.each do |err|
          flash.now[:error] = err
        end
      end
      render 'static_pages/home'
    end
  end

end
