require 'rails_helper'

RSpec.describe RanksHelper, type: :helper do
  describe 'fetch_rank' do
    it '順位を取得して返すこと' do
      total_value = %w[apple orange banana]
      value = 'orange'
      expect(helper.fetch_rank(total_value, value)).to eq 2
    end
  end

  describe 'show_rank' do
    context 'rankingが3以下の時' do
      it '該当する順位のランキング画像を返すこと' do
        expect(helper.show_rank(3)).to eq '<img alt="ランキング3位画像" src="/packs-test/media/images/home_rank_3-019362cd3fdb6c005010fffbda66be65.png" width="130" height="80" />'
      end
    end

    context 'rankingが3より上の時' do
      it '該当する順位の文字列を返すこと' do
        expect(helper.show_rank(4)).to eq '第4位'
      end
    end
  end
end
