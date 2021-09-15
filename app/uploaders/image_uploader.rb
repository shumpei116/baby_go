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

  process resize_to_fit: [800, 800]

  version :thumb do
    process resize_to_fill: [640, 420, 'Center']
  end

  def size_range
    1..5.megabytes
  end

  def extension_allowlist
    %w(jpg jpeg gif png)
  end
end
