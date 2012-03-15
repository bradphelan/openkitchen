module ApplicationHelper

  def s3_expiry
    Time.zone.now.beginning_of_day.since 25.hours
  end

  def profile_avatar_image(user, version)

    dim = case version
    when :medium
      [300, 300]
    when :thumb
      [100, 100]
    when :mini_thumb
      [50, 50]
    end


    if user.avatar.file?
      uri = user.avatar.expiring_url(s3_expiry, version)
      style = nil
    else
      uri = "chef.jpg"
      style = "width: #{dim[0]}px; height: #{dim[1]}px"
    end

    image_tag uri, :class => "avatar #{version}", :style => style
  end
end
