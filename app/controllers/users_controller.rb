class UsersController < ApplicationController
  def change_view
    changev = params[:changev]
    if changev == "Active"
      session[:changev] = "All"
    elsif changev == "All"
      session[:changev] = "Inactive"
    else
      session[:changev] = "Active"
    end
    redirect_to session[:forwarding_url]
  end

  def genpassword(user)
    genword = (10000000 + rand(10000000)).to_s
    puts "password " + genword
    user.password =  genword
    user.password_confirmation = genword
  end
end
