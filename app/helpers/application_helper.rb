module ApplicationHelper

  def add_error(message, status)
    if status == "error"
      flash.now[:error] = message if message.present?
    elsif status == "success"
      flash.now[:success] = message if message.present?
    else
      flash.now[:notice] = message if message.present?
    end
  end
  
end
