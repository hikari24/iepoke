require 'rails_helper'

describe 'カテゴリーのテスト' do
	let!(:user) { create(:user) }
	let!(:category) { create(:category) }
	let!(:food) { create(:food) }
	before do
	visit new_user_session_path
	fill_in 'user[email]', with: user.email
  	fill_in 'user[password]', with: user.password
  	click_button 'ログイン'
  	click_button '食材を登録する'
  	visit new_food_path
  	click_button '追加'
  	end

	context 'カテゴリーの表示' do
		it 'カテゴリーの一覧を表示する' do
  			visit categories_path
  			expect(page).to have_content 'カテゴリー一覧'
  		end
  		it 'カテゴリー名のリンク先が正しい' do
  			visit categories_path
  			expect(page).to have_content '肉類'
  			expect(page).to have_link category.name, href: foods_path(category_id: category.id)
  		end
  	end
  	context 'カテゴリーの追加・編集' do
		it '追加に成功する' do
			visit categories_path
			fill_in "category[name]", with: "肉類"
			click_button "追加"
			expect(page).to have_content '追加されました'
		end
		it '編集に成功する' do
			visit edit_category_path(category)
			click_button '保存'
			expect(page).to have_content 'カテゴリーが編集されました'
		end
		it '編集に失敗する' do
			visit edit_category_path(category)
			fill_in 'category[name]', with: ''
			click_button '保存'
			expect(page).to have_content 'エラー'
		end
	end

end 