class MoviesController < ApplicationController
	before_action :authenticate_user!, only: [:new, :edit, :destroy]
	before_action :find_movie, only: [:show, :edit, :update, :destroy]
	

	def index

		if params[:categoria].blank?
			@movie = Movie.all.order("created_at DESC").page(params[:page]).per(3)

		else
			@category_id = Category.find_by(name: params[:categoria]).id
			@movie = Movie.where(:category_id => @category_id).order("created_at DESC").page(params[:page]).per(12)
		end

	end

	def show
		if @movie.reviews.blank?
			@average = 0
		else
			@average = @movie.reviews.average(:rating).round(2)
		end
		omdb = RestClient.get('https://www.omdbapi.com/', {params: {t: @movie.title, apikey: '847f91b9'}})
		omdb=JSON.parse(omdb)
		@image = omdb['Poster']
		@director = omdb['Director']
		@year = omdb['Year']
		@genre = omdb['Genre']
		@description = omdb['Plot']
		@runtime = omdb['Runtime']
		@actors = omdb['Actors']
		@imdbID = omdb['imdbID']

		@rev = @movie.reviews.page(params[:page]).per(10)

	end

	def new
		@movie = current_user.movies.build
		@categories =Category.all.map{ |c| [c.name, c.id] }
	end

	def edit
		@categories =Category.all.map{ |c| [c.name, c.id] }
	end

	def update
		@movie.category_id = params[:category_id]
		if @movie.update(movie_params)
			redirect_to movie_path(@movie)
		else

			render 'edit'
		end
	end

	def destroy
		@movie.destroy
		redirect_to root_path
		

	end

	def create
		@movie = current_user.movies.build(movie_params)
		@movie.category_id = params[:category_id]

		if @movie.save
			redirect_to root_path
		else
			render 'new'
		end
	end
	
	def find_movie
		@movie = Movie.find(params[:id])
	end


	private
	def movie_params
		params.require(:movie).permit(:title, :description, :director, :category_id)
	end
end

