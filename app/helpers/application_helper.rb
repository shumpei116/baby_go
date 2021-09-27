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
      title: 'Baby_Go',
      reverse: true,
      separator: '|',
      description: 'Baby_Gpは授乳室やおむつ交換スペースが完備された施設、赤ちゃんと一緒に入れる飲食店などの情報を共有・検索するためのWEBサービスです',
      keywords: 'Baby_Go,ベイビーゴー,赤ちゃんがいても,赤ちゃんと',
      canonical: request.original_url,
      noindex: !Rails.env.production?,
      og: {
        site_name: 'Baby_Go',
        title: 'Baby_Go',
        description: 'Baby_Gpは授乳室やおむつ交換スペースが完備された施設、赤ちゃんと一緒に入れる飲食店などの情報を共有・検索するためのWEBサービスです',
        type: 'website',
        url: request.original_url,
        image: image_pack_tag('media/images/logo.png'),
        locale: 'ja_JP'
      },
      twitter: {
        card: 'summary'
      }
    }
  end
end
