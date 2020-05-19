require 'rails_helper'

describe 'ユーザー認証のテスト' do
	describe 'ユーザー新規登録' do
		context '新規登録' do 
		 	it '新規登録に成功する' do
		 		visit new_user_registration_path
		 		fill_in 'user[name]', with: "iepoke"
		 		fill_in 'user[email]', with: "iepoke@email.com"
		 		fill_in 'user[password]', with: "password"
		 		fill_in 'user[password_confirmation]', with: "password"

		 		click_button '新規登録'
		 		expect(current_path).to eq(root_path)
		 	end
		 	it '新規登録に失敗する' do
		 		visit new_user_registration_path
		 		fill_in 'user[name]', with: ""
		 		fill_in 'user[email]', with: ""
		 		fill_in 'user[password]', with: ""
		 		fill_in 'user[password_confirmation]', with: ""

		 		click_button '新規登録'
		 		expect(page).to have_content 'エラー'

		 	end
		 end
	end
	describe 'ユーザーログイン' do
		before do
			visit new_user_session_path
		end
		context 'ログイン' do
			it 'ログインに成功する' do
				fill_in 'user[email]', with: "iepoke@email.com"
		 		fill_in 'user[password]', with: "password"
		 		#click_button 'ログイン'
		 		#find('button[type="submit"]').click
		 		click_on 'ログイン'

		 		expect(current_path).to eq(root_path)
			end
			it 'ログインに失敗する' do
				fill_in 'user[email]', with: ""
		 		fill_in 'user[password]', with: ""
		 		click_button 'ログイン'

		 		expect(page).to have_content 'メールアドレスまたはパスワードが違います'
			end
		end
	end
end

describe 'マイページのテスト' do
	let!(:user) { create(:user) }
	before do
		visit new_user_session_path
		fill_in 'user[email]', with: user.email
  		fill_in 'user[password]', with: user.password
  		click_button 'ログイン'
  	end
  	context '表示の確認' do
		it 'マイページの表示' do
			visit root_path
			click_on 'マイページ'
			visit users_path
			expect(page).to have_content 'マイページ'
		end
		it 'マイページ編集画面を表示する' do
			visit users_path
			click_on '登録内容の変更', match: :first
			expect(current_path).to eq(edit_users_path)
		end

		it '登録内容を変更する' do
			visit edit_users_path
			fill_in 'user[current_password]', with: user.password
			click_on '更新'
			expect(page).to have_content 'アカウント情報を変更しました'
		end
	end
end