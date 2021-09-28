module ApplicationHelper
  BASE_TITLE = 'Baby_Go'.freeze
  def full_title(page_title: '')
    if page_title.blank?
      BASE_TITLE
    else
      "#{page_title} - #{BASE_TITLE}"
    end
  end

  def default_meta_tags
    {
      site: 'Baby_Go',
      description: 'Baby_Goは授乳室やおむつ交換スペースが完備された施設、赤ちゃんと一緒に入れる飲食店などの情報を共有・検索するためのWEBサービスです',
      keywords: 'Baby_Go,ベイビーゴー,赤ちゃんがいても,赤ちゃんと',
      charset: 'UTF-8',
      canonical: request.original_url,
      noindex: !Rails.env.production?,
      icon: [
        { href: asset_pack_url('media/images/home_image.jpg') },
        { href: asset_pack_url('media/images/home_image.jpg'), rel: 'apple-touch-icon', sizes: '180x180',
          type: 'image/jpg' }
      ],
      og: {
        site_name: :site,
        title: 'Baby_Go',
        description: :description,
        type: 'website',
        url: request.original_url,
        image: asset_pack_url('media/images/og_logo.png'),
        locale: 'ja_JP'
      },
      twitter: {
        card: 'summary',
        site: '@o_shumpei'
      },
      fb: {
        app_id: '1219295798572399'
      }
    }
  end
end
