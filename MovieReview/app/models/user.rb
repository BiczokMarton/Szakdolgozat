class User < ApplicationRecord
		searchkick word_middle: [:firstname, :surname]

	def search_data
		{
		firstname: firstname,
		surname: surname
		}
	end
	serialize :follows, Array
	has_many :movies
	has_many :reviews
	has_attached_file :user_img, :styles => { user_index: "250x250>", user_show: "900x900>" }, default_url: "/images/:style/missing.png"
 	validates_attachment_content_type :user_img, content_type: /\Aimage\/.*\z/
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  
end
