class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :get_plugins

  def sort_order(default)
    "#{(params[:c] || default.to_s).gsub(/[\s;'\"]/,'')} #{params[:d] == 'down' ? 'DESC' : 'ASC'}"
  end 
  
  def can_manage_all?
     if current_user and can? :manage, :roles
      return
    end
    flash[:alert] = "You aren't authorized to view this!"
    redirect_to root_path
  end

  def get_space_actions
    UserAction.page(pagination_hash(params[:site_page]) )
  end

  def get_user_log
    UserAction.where(obj_type: 'User').page(pagination_hash.merge(params[:users_page]))
  end

  def log_action(event, object)
    action        = UserAction.new event: event
    action.object = object
    action.user   = current_user

    if !action.save
      flash[:alert] = "Could not log action."
    end
  end

  def get_plugins
    @plugin_menu_items = []
    plugins = Plugins.all
    plugins.each do |plugin|
      p = []
      p[0] = plugin.humanize.pluralize
      p[1] = plugin.underscore + "_path"

      @plugin_menu_items << p
    end
  end

  def pagination_hash
    {
      page:     (params[:page]     or 1),
      per_page: (params[:per_page] or 1),
      order:    "updated_at DESC"
    }
  end

end
