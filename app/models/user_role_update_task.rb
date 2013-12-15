class UserRoleUpdateTask
  require_relative '../../config/environment'

  def self.update
    update_user('annamik@gmail.com');
    update_user('gshilin@gmail.com');
    update_user('mgorodetsky@gmail.com');
  end


  def self.update_user(email)
    user = User.find_by_email(email)
    if(user)
      user.roles << Role.find_by_name("Admin")
      user.save
      puts  "#{user.email} - updated"
    else
      puts  "no such user for #{email}"
    end
  end
end