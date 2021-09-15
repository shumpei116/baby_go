require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'full_title' do
    context 'page_titleがないとき' do
      it 'BASE_TITLEのみ表示されること' do
        expect(helper.full_title).to eq 'Baby_Go'
      end
    end

    context 'page_titleがあるとき' do
      it 'page_title - BASE_TITLEが表示されること' do
        expect(helper.full_title(page_title: '新規登録')).to eq '新規登録 - Baby_Go'
      end
    end
  end
end
