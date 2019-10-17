class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         # devise :registerable,
         # :recoverable, :rememberable, :validatable
  has_many :api_tokens
  
  enum otp_module:{disabled: 0,enabled: 1},_prefix: true
  attr_accessor :otp_code_token

  def generate_token
  	Digest::SHA1.hexdigest([DateTime.now, rand].join)
  end

  def abc
    puts "himanshu"
  end
end
