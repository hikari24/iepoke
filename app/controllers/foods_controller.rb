class FoodsController < ApplicationController
	 before_action :authenticate_user!
	 before_action :correct_user, only:[:show, :edit, :destroy]
	 before_action :set_search, only: [:index]

  	def set_search
    	@q = Food.ransack(params[:q])
    	@foods = @q.result
    	@categories = Category.where(user_id: current_user.id)
  	end

	def new
		@food = Food.new
	end

	def create
		@food = Food.new(food_params)
		@food.user_id = current_user.id
		if @food.save
		redirect_to food_path(@food)
		flash[:notice] = "食材が登録されました。"
		else
		render :new
		end
	end

	def show
		@food = Food.find(params[:id])
	end

	def index
		if params[:category_id] #カテゴリー一覧から飛んできたとき			
			@one_foods = Food.where(category_id: params[:category_id])
			@foods = @one_foods.all.page(params[:page])
		elsif params[:q] #検索フォームで検索したとき
			@q = Food.ransack(params[:q])
  			@search_foods = @q.result
  			@foods = @search_foods.where(user_id: current_user.id).page(params[:page])
  		elsif params[:expiry_date] #本日までの消費期限食材リンクから飛んできたとき 			
  			food = Food.where(user_id: current_user.id)
			@foods = food.where(expiry_date: [100.days.ago..Date.today]).page(params[:page])#当日までの消費期限の食材を出す
		else
			@foods = Food.where(user_id: current_user.id).page(params[:page])
		end
	end

	def edit
		@food = Food.find(params[:id])
	end

    def update
    	@food = Food.find(params[:id])
    	#@food.user_id = current_user.id
    	if @food.update(food_params)
    		redirect_to food_path(@food)
    		flash[:notice] = "食材が編集されました。"
    	else
    		render 'edit'
    	end
    end

	def destroy
		@food = Food.find(params[:id])
		@food.destroy
		redirect_to foods_path
	end

	def wish_list
		food = Food.where(wish_list: true)
		@foods = food.where(user_id: current_user.id).page(params[:page]).per(15)
	end

	def wish_list_create
		@food = Food.find(params[:id])
		@food.update(wish_list: true)
		#redirect_to request.referrer || root_url
	end

	def wish_list_destroy
		@food = Food.find(params[:id])
		@food.update(wish_list: false)
		#redirect_to request.referrer || root_url
	end

	private
	def food_params
		params.require(:food).permit(:user_id, :category_id, :name, :quantity, :purchase_date, :expiry_date, :wish_list, :image)
	end

	def correct_user
		@food = Food.find(params[:id])
		redirect_to foods_path unless @food.user == current_user
	end

	def search_params
    	params.require(:q).permit(:sorts, :category_id)
 	end
end
