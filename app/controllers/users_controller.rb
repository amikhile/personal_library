class UsersController < ApplicationController
  before_filter :get_user, :only => [:index, :new, :edit]
  load_resource :only => [:show, :new, :destroy, :edit, :update]
  skip_before_filter :authenticate_user!, :check_logged_in, :load_filters_and_labels, :load_from_kmedia, :set_data


  def after_login
    #http://box.kbb1.com/after_login?name=&surname=&username=annamik&email=annamik@gmail.com
    #http://localhost:3000/after_login?name=&surname=&username=annamik&email=annamik@gmail.com
    name = params['name']
    last_name = params['surname']
    username=params['username']
    email = params['email']
    @user = User.find_by_email(email)
    unless @user
      @user = User.new
      @user.roles << Role.find_by_name("AdvancedUser") #unless  @user.roles.collect(&:name).include? "AdvancedUser"
      @user.email = email
      @user.first_name=name
      @user.last_name=last_name
      @user.username=username
      @user.save
    end

    sign_in @user
    redirect_to inbox_files_path
  end

  def my_sign_in
  end

end
