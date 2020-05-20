require 'rails_helper'

describe '食材のテスト' do
	let!(:user) { create(:user) }
  let!(:category) { create(:category, user_id: user.id) }
	#let!(:food) { create(:food, user_id: user.id, category_id: category.id) }
	before do
	visit new_user_session_path
	fill_in 'user[email]', with: user.email
  fill_in 'user[password]', with: user.password
  click_button 'ログイン'
  visit root_path
  click_button '食材を登録する'
  visit new_food_path
  #click_button '追加'
  #visit categories_path
  #fill_in "category[name]", with: "肉類"
  #click_button "追加"
  #click_button "食材登録"
  #visit new_food_path
  end
    describe '登録のテスト' do
      let(:food) { create(:food, user_id: user.id, category_id: category.id) }
        it '登録フォームが表示される' do
  		    expect(page).to have_content '食材登録'
  	    end
        it '登録に成功する' do
          select "肉類", from: "food_category_id"
          #find("option[value=肉類]").select_option
          fill_in 'food[name]', with: '豚肉'
          fill_in 'food[quantity]', with: '200グラム'
          fill_in 'food[purchase_date]', with: '2020/05/01'
          fill_in 'food[expiry_date]', with: '2020/05/01'
          click_button '登録', match: :first
          expect(current_path).to eq food_path(food)
        end
        it '登録に失敗する' do
          visit new_food_path
          click_button '登録'
          expect(page).to have_content 'エラー'
        end	
    end
    describe '編集のテスト' do
      let!(:food) { create(:food, user_id: user.id, category_id: category.id) }
        it '編集画面に遷移する' do
          visit edit_food_path(food)
          expect(current_path).to eq('/foods/' + food.id.to_s + '/edit')
        end
        it '編集に成功する' do
          visit edit_food_path(food)
          click_button '保存'
          expect(page).to have_content '食材が編集されました'
        end
        it '編集に失敗する' do
          visit edit_food_path(food)
          fill_in 'food[name]', with: ''
          click_button '保存'
          expect(page).to have_content 'エラー'
        end
    end

    describe '表示のテスト' do
      let!(:food) { create(:food, user_id: user.id, category_id: category.id) }
        it '食材一覧が表示される' do
          visit foods_path
          expect(page).to have_content '食材一覧'
        end
        it '食材名のリンク先が正しい' do
          visit foods_path
          expect(page).to have_link food.name, href: food_path(food)
        end
        it '食材詳細が表示される' do
          visit food_path(food)
          expect(page).to have_content '食材詳細'
        end
    end
end	
