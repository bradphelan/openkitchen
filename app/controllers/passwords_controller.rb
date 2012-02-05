class PasswordsController < Devise::PasswordsController

  def update
    super
    if resource.errors.empty?
      # Successfully changed password
      if not resource.registration_completed_at
        resource.registration_completed_at = Time.zone.now
        resource.save
        set_flash_message(:notice, "You have completed registration") if is_navigational_format?
      end
    end
  end

end
