class User < ApplicationRecord
  include BCrypt

  has_many :jokes
  has_many :answers
  has_many :comments
  has_many :votes

  validate :validate_password
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  validates :username, :email, :password, presence: true


  def password
    @password ||= Password.new(hashed_password)
  end

  def password=(plain_text_password)
    @raw_password = plain_text_password
    @password = Password.create(plain_text_password)
    self.hashed_password = @password
  end

  def authenticate(plain_text_password)
    self.password == plain_text_password
  end

  def validate_password
    if @raw_password.length == 0
      errors.add(:password, "is required")
    elsif
      @raw_password.length < 8
      errors.add(:password, "must be at least 8 characters")
    end
  end


end
