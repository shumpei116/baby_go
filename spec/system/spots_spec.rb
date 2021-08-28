require 'rails_helper'

RSpec.describe 'Spots', type: :system do
  xdescribe '表示とリンクのテスト', js: true do
    let!(:store1) {
      create(:store, name: 'あかちゃん本舗', introduction: '綺麗な授乳室でした', postcode: '1111111', prefecture_code: '北海道',
                     city: '函館市1-1-1')
    }
    let!(:store2) {
      create(:store, name: 'ベビーレストラン', introduction: '個室の和室があって赤ちゃんと一緒でもゆっくりできました', postcode: '1234567',
                     prefecture_code: '沖縄県', city: '那覇市1-1-1')
    }

    before do
      page.accept_confirm do
        visit spots_path
      end
    end

    it '地図が表示されていて施設の数だけマーカーが立っていること' do
      expect(page).to have_css '.gm-style'
      expect(page).to have_css '#gmimap0'
      expect(page).to have_css '#gmimap1'
    end
  end
end
