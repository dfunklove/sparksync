class AdminConstraint
  def matches?(request)
    @user_id = request.session['user_id']
    if (@user_id)
      if (!@user || !(@user.id == @user_id))
        @user = User.find(@user_id)
      end
      return @user && @user.admin?
    else
      return false
    end
  end
end

class TeacherConstraint
  def matches?(request)
    return request.session['user_id'] != nil
  end
end

Rails.application.routes.draw do
  constraints(AdminConstraint.new) do
    root 'admins#dashboard'
  end
  constraints(TeacherConstraint.new) do
    root 'lessons#new'
  end
  root 'sessions#new'

  get '/lessons/new'
  get '/lessons/checkout'
  post '/lessons/finishCheckout'
  patch '/lessons/finishCheckout'
  post '/lessons',   to: 'lessons#create'
  get '/admins/new'
  get '/admins/dashboard'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :teachers
  resources :dateviews
end
