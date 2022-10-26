class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    if resource.class == Creator
      if resource.sign_in_count == 1
        edit_creator_registration_path
      else
        root_path
        # edit_creator_path
      end
    elsif resource.class == AdminUser
      admin_root_path
    else
      root_path
    end
  end
end
