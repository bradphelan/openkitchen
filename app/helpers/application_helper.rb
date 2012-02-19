module ApplicationHelper
  S3_EXPIRY = 120
  def profile_avatar_image(profile, version)

    case version
    when :medium
      [300, 300]
    when :thumb
      [100, 100]
    when :mini_thumb
      [50, 50]
    end

    if profile.avatar.file?
      uri = profile.avatar.expiring_url(S3_EXPIRY, version)
    else
      uri = "chef.jpg"
    end

    image_tag uri, :class => "avatar #{version}"
  end
end
