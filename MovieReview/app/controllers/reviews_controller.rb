class ReviewsController < ApplicationController
before_action :authenticate_user!, only: [:new, :edit, :destroy]
	
before_action :find_movie
before_action :find_review , only:[:edit, :update, :destroy]

	def new
		@review = Review.new
	end

	def create
		create_params = review_params
		create_params[:rating] = 0 if review_params[:rating] == ''
		@error = ''
		@review = Review.new(create_params)
		@review.movie_id = @movie.id
		@review.user_id = current_user.id
		if @review.save
			redirect_to movie_path(@movie)
		else
			@error = 'You already reviewd this movie!'
			render 'new'
		end
	end

	def edit
	end
	

	def update
		update_params = review_params
		update_params[:rating] = 0 if review_params[:rating] == ''
		if @review.update(update_params)
			redirect_to movie_path(@movie)
		else
			render 'edit'
		end
	end

	def destroy
		@review.destroy
		redirect_to movie_path(@movie)
	end

	private
		def review_params
			params.require(:review).permit(:rating, :comment)
		end

		def find_movie
			@movie = Movie.find(params[:movie_id])
		end

		def find_review
			@review= Review.find(params[:id])
		end

		def find_user
			@user=User.find(params[:user_id])
		end
end
