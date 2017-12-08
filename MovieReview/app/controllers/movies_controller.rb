class MoviesController < ApplicationController
	before_action :authenticate_user!, only: [:new, :edit, :destroy]
	before_action :find_movie, only: [:show, :edit, :update, :destroy]
	

	def index

		if params[:category].blank?
			@movie = Movie.all.order("created_at DESC").page(params[:page]).per(9)


		else
			@category_id = Category.find_by(name: params[:category]).id
			@movie = Movie.where(:category_id => @category_id).order("created_at DESC").page(params[:page]).per(9)
		end
		@image = {}
		@average = {}
		@movie.each do |movie|
			omdb = RestClient.get('https://www.omdbapi.com/', {params: {t: movie.title,y: movie.year, apikey: '847f91b9'}})
			omdb=JSON.parse(omdb)
			@image[movie.id] = omdb['Poster']
			if movie.reviews.blank?
				@average[movie.id] = 0
			else
				sum = 0
				i = 0
				movie.reviews.each do |review|
				 	next if review.rating.zero?
				 	sum += review.rating
				 	i += 1 
				end
				average = i.zero? ? 0 : sum.to_f / i 
				@average[movie.id] = average.round(2)
			end
		end
	end

	def search

		
		if params[:title].present?
			@movie= Movie.search(params[:title], fields: [:title], misspellings: {below: 5,edit_distance: 2} ,page: params[:page], per_page: 9)
			

		else
			@movie = Movie.all

		end
				@image = {}
		@average = {}
		@movie.each do |movie|
			omdb = RestClient.get('https://www.omdbapi.com/', {params: {t: movie.title,y: movie.year, apikey: '847f91b9'}})
			omdb=JSON.parse(omdb)
			@image[movie.id] = omdb['Poster']
			if movie.reviews.blank?
				@average[movie.id] = 0
			else
				sum = 0
				i = 0
				movie.reviews.each do |review|
				 	next if review.rating.zero?
				 	sum += review.rating
				 	i += 1 
				end
				average = i.zero? ? 0 : sum.to_f / i 
				@average[movie.id] = average.round(2)
			end
		end

	end 

	def autocomplete
	render json: Movie.search(params[:title], {
      fields: ["title"],
      match: :word_start,
      load: false,
      misspellings: {below: 5}
    }).map(&:title)
	end

	def show
		if @movie.reviews.blank?
			@average = 0
		else
			sum = 0
			i = 0		
			@movie.reviews.each do |review|
		 		next if review.rating.zero?
		 		sum += review.rating
				i += 1 
			end
			average = i.zero? ? 0 : sum.to_f / i 
			@average = average.round(2)
		end
		omdb = RestClient.get('https://www.omdbapi.com/', {params: {t: @movie.title,y:@movie.year, apikey: '847f91b9'}})
		omdb=JSON.parse(omdb)
		@image = omdb['Poster']
		@director = omdb['Director']
		@year = omdb['Year']
		@genre = omdb['Genre']
		@description = omdb['Plot']
		@runtime = omdb['Runtime']
		@actors = omdb['Actors']
		@imdbID = omdb['imdbID']

		@rev = @movie.reviews.page(params[:page]).per(6)

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
		@movie.reviews.destroy_all
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
		params.require(:movie).permit(:title, :category_id, :year)
	end
end

