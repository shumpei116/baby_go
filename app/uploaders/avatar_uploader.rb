class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  if Rails.env.development?
    storage :file
  elsif Rails.env.test?
    storage :file
  else
    storage :fog
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url(*args)
    "/images/fallback/" + [version_name, "default.jpg"].compact.join('_')
  end

  process resize_to_fit: [800, 800]

  version :thumb do
    process resize_and_pad: [300, 200]
  end

  version :medium_thumb do
    process resize_and_pad: [250, 167]
  end

  def size_range
    1..5.megabytes
  end

  def extension_allowlist
    %w(jpg jpeg gif png)
  end

  def content_type_whitelist
    /image\//
  end
end
