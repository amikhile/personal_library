class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable , :registerable, :recoverable,:token_authenticatable, :validatable
  devise  :rememberable, :trackable, :database_authenticatable


  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :username, :password, :password_confirmation, :remember_me, :first_name, :last_name

  has_and_belongs_to_many :roles, :uniq => true
  has_and_belongs_to_many :labels, :uniq => true
  has_and_belongs_to_many :filters, :uniq => true
  has_many :download_tasks, :uniq => true, :dependent => :destroy

  # Generate a token by looping and ensuring does not already exist.
  #def generate_token(column = :reset_password_token)
  #  token = ''
  #  loop do
  #    token = SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz')
  #    break token unless User.where(column => token).first
  #  end
  #  update_attribute column, token
  #end

  def role?(role)
    return !!self.roles.find_by_name(role.to_s.camelize)
  end

  protected
  def password_required?
    false
  end
end
