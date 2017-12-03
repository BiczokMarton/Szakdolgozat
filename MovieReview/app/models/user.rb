class User < ApplicationRecord
	has_many :movies
	has_many :reviews
	has_attached_file :user_img, :styles => { user_index: "250x250>", user_show: "700x700>" }, default_url: "/images/:style/missing.png"
 	validates_attachment_content_type :user_img, content_type: /\Aimage\/.*\z/
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  
end
