class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :force_utf8_params
  
  def force_utf8_params
    traverse = lambda do |object, block|
      if object.kind_of?(Hash)
        object.each_value { |o| traverse.call(o, block) }
      elsif object.kind_of?(Array)
        object.each { |o| traverse.call(o, block) }
      else
        block.call(object)
      end
      object
    end
    force_encoding = lambda do |o|
      o.force_encoding(Encoding::UTF_8) if o.respond_to?(:force_encoding)
    end
    traverse.call(params, force_encoding)
  end
  
  private
#  def admin_required
#    redirect_to '/admin/login' unless user_signed_in? && current_user.name=="admin"
#  end

#  def current_tab
#    return controller.controller_name
#
#  end
end
