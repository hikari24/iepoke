class CategoriesController < ApplicationController
	before_action :authenticate_user!
	def create
		@category = Category.new(category_params)
		if @category.save
		redirect_to categories_path
		flash[:notice] = "カテゴリーが追加されました。"
		else
		redirect_to categories_path
		flash[:alert] = "カテゴリーを入力してください。"
		end
	end

	def index
		@category = Category.new
		@user = current_user.id
		@categories = Category.where(user_id: current_user.id).page(params[:page])
	end

	def edit
		@category = Category.find(params[:id])
	end

	def update
		@category = Category.find(params[:id])
		if @category.update(category_params)
		redirect_to categories_path
		flash[:notice] = "カテゴリーが編集されました。"
		else
		render 'edit'
		end
	end

	def destroy
		@user = current_user.id
		@category = Category.find(params[:id])
		@category.destroy
		flash[:notice] = "カテゴリーが削除されました。"
		redirect_to categories_path
	end

	private
	def category_params
		params.require(:category).permit(:name).merge(user_id: current_user.id)
	end
end
