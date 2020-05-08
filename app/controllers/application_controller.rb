class ApplicationController < ActionController::Base
	before_action :configure_permitted_parameters, if: :devise_controller?

	def after_sign_out_path_for(resource)
    	root_path # ログアウト後に遷移するpathを設定
  	end

	protected
  	def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email])
    # 新規登録時(sign_up時)にnameというキーのパラメーターを追加で許可する
  	end
end