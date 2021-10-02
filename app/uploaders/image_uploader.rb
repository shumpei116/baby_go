class ImageUploader < CarrierWave::Uploader::Base
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
    '/images/fallback/' + [version_name, 'default_store.jpeg'].compact.join('_')
  end

  process resize_and_pad: [800, 540, "#ffffff"]

  version :thumb do
    process resize_and_pad: [640, 420, "#ffffff"]
  end

  def size_range
    1..5.megabytes
  end

  def extension_allowlist
    %w(jpg jpeg gif png)
  end
end
