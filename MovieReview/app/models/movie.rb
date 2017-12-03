class Movie < ApplicationRecord
	belongs_to :user
	belongs_to :category
	has_many :reviews
	#Paperclip
	#has_attached_file :movie_img, styles: { movie_index: "250x250>", movie_show: "700x700>" }, default_url: "/images/:style/missing.png"
  	#validates_attachment_content_type :movie_img, content_type: /\Aimage\/.*\z/
end
