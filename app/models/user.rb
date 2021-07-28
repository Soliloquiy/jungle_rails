class User < ActiveRecord::Base
  has_secure_password
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :password, presence: true, length: { minimum: 5 }
  validates_uniqueness_of :email, :case_sensitive => false
  validates :email, presence: true
  validates :password_confirmation, presence: true
  

  
  
  def self.authenticate_with_credentials(email, password)
    @user = User.find_by(email: email)
    if email == nil || password == nil
      nil
    else
    @user = User.find_by_email(email.strip.downcase)
    end
    if @user && @user.authenticate(password)
      @user
    else
      nil
    end
  end
end