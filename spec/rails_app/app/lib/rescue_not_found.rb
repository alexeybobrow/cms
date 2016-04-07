module RescueNotFound
  def self.included(base)
    base.class_eval do
      unless Rails.env.development?
        rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
        rescue_from ActionController::RoutingError, with: :render_not_found
        rescue_from ActionController::UnknownController, with: :render_not_found
        rescue_from ::AbstractController::ActionNotFound, with: :render_not_found
        rescue_from ActionView::MissingTemplate, with: :render_not_found
        rescue_from ActionController::RoutingError, with: :render_not_found
      end
    end
  end

  def raise_not_found!
    raise ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
  end
private

  def render_not_found(exception=nil)
    render "/errors/404", formats: [:html], handlers: [:haml], status: 404
  end
end
