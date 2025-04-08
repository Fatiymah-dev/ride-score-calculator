class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # method to handle record not found errors
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: "#{exception.model} not found" }, status: :not_found
  end
end
