class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #=============Associations======================
  has_many :api_tokens
  has_many :trips
  has_many :accounts
  has_one :wallet
  has_many :conversations
  has_many :chat_messages, through: :conversations
  #=============Validations=======================
  validates :first_name, :last_name, :dob, :country, presence: true, on: :create
  validates :first_name, :last_name, format: {with: /\A[a-zA-Z0-9 ]+\z/}
  #=============Callbacks=========================
  after_create :create_wallet

  #===============================================


  def self.customers
    self.where(role: 'user')
  end

  def generate_token
  	Digest::SHA1.hexdigest([DateTime.now, rand].join)
  end

  def full_name
    [first_name, last_name].compact.join(" ")
  end

  def validate_chat_session
    if self.conversations.last.present?
      last_message = self.chat_messages.last
      (DateTime.now.utc - last_message.created_at.utc) > 10.minutes
    else
      true
    end
  end

  private

  def create_wallet
    self.wallet.create(balance: 0)
  end

end
