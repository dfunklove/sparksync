class AdminConstraint
  def matches?(request)
    #request.session['user_id'].present?
    return false
  end
end

class TeacherConstraint
  def matches?(request)
    return request.session['user_id'] != nil
  end
end

Rails.application.routes.draw do
  constraints(TeacherConstraint.new) do
    root 'lessons#new'
  end
  constraints(AdminConstraint.new) do
    root 'admins#dashboard'
  end
  root 'sessions#new'

  get '/lessons/new'
  get '/lessons/checkout'
  post '/lessons/finishCheckout'
  patch '/lessons/finishCheckout'
  post '/lessons',   to: 'lessons#create'
  get '/admins/new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
end
