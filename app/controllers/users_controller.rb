class UsersController < ApplicationController
  def genpassword(user)
    genword = (10000000 + rand(90000000)).to_s
    puts "password " + genword
    user.password =  genword
    user.password_confirmation = genword
  end
end
