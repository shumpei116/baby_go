module RanksHelper
  def fetch_rank(total_value, value)
    total_value.index(value) + 1
  end

  def show_rank(ranking)
    if ranking >= 1 && ranking <= 3
      image_pack_tag("media/images/home_rank_#{ranking}.png", size: '130x80', alt: "ランキング#{ranking}位画像")
    else
      "第#{ranking}位"
    end
  end
end
