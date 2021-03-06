class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :wikis, through: :collaborators
  has_many :collaborators


  def user_status
    self.premium ? "Premium user" : "Regular user"
  end

end
