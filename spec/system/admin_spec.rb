require 'rails_helper'

describe 'アドミンのテスト' do
	describe "ログイン" do
		context 'ログイン画面に遷移' do
			let(:admin) { create(:admin)}
			before do
				visit new_admin_session_path
			end
			it 'ログインできる' do
		 		fill_in 'admin[email]', with: admin.email
		 		fill_in 'admin[password]', with: admin.password
		 		click_button 'ログイン'

		 		expect(current_path).to eq(admins_root_path)
			end
			it 'ログインできない' do
				fill_in 'admin[email]', with: ""
		 		fill_in 'admin[password]', with: ""
		 		click_button 'ログイン'

		 		expect(current_path).to eq(new_admin_session_path)
			end
		end
	end
	describe '表示のテスト' do
		let(:admin) { create(:admin)}
		let!(:user) { create(:user) }
		before do
			visit new_admin_session_path
			fill_in 'admin[email]', with: admin.email
		 	fill_in 'admin[password]', with: admin.password
		 	click_button 'ログイン'
		end
		context 'ハンバーガーメニューの表示' do
			it '管理者メニューが表示される' do
				expect(page).to have_content '管理者トップ'
				expect(page).to have_content '会員一覧'
				expect(page).to have_content 'ログアウト'
			end

		end
		context '会員情報の表示' do
			it '会員一覧画面が表示される' do
				visit admins_root_path
				click_link '会員一覧', match: :first
				
				expect(page).to have_content '会員一覧'
				expect(current_path).to eq(admins_users_path)
			end
		end
	end
end
