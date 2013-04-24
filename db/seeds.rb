# encoding: UTF-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts '--> Roles'
[
    {:name => 'Admin', :description => 'כל יכול'},
    {:name => 'AdvancedUser', :description => 'Can search for secure files'},
    {:name => 'SimpleUser', :description => 'User to work with the personal library'}
].each{|r| Role.find_or_create_by_name(r)}

#puts '--> Users'
#[
#    {:user => {:email => 'mgorodetsky@gmail.com'}, :role => 'Admin'},
#    {:user => {:email => 'gshilin@gmail.com'}, :role => 'Admin'},
#    {:user => {:email => 'ramigg@gmail.com'}, :role => 'Admin'},
#    {:user => {:email => 'annamik@gmail.com'}, :role => 'Admin'},
#    {:user => {:email => 'simple@gmail.com'}, :role => 'SimpleUser'}
#].each{|e|
#  user = User.find_or_create_by_email(e[:user])
#  user.roles << Role.find_by_name(e[:role])
#}

