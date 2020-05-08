class CategoriesController < ApplicationController
	def create
		@category = Category.new(category_params)
		@category.user_id = current_user.id
		@category.save
		redirect_to categories_path
	end

	def index
		@category = Category.new
		@user = current_user.id
		@categories = Category.where(user_id: current_user.id)
	end

	def edit
		@category = Category.find(params[:id])
	end

	def update
		@category = Category.find(params[:id])
		@category.update(category_params)
		redirect_to categories_path
	end

	def destroy
		@user = current_user.id
		@category = Category.find(params[:id])
		@category.destroy
		redirect_to categories_path
	end

	private
	def category_params
		params.require(:category).permit(:user_id, :name)
	end
end
