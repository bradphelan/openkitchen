class RegistrationsController < Devise::RegistrationsController
  def create
    super
    if resource.errors.empty?
      resource.registration_completed_at = Time.zone.now
      resource.save
      # TODO Add I18N for below message
      set_flash_message(:notice, "You have completed registration") if is_navigational_format?
    end
  end
end
