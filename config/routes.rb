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
    @user_id = request.session['user_id']
    if (@user_id)
      if (!@user || !(@user.id == @user_id))
        @user = User.find(@user_id)
      end
      return @user && @user.teacher?
    else
      return false
    end
  end
end

class PartnerConstraint
  def matches?(request)
    @user_id = request.session['user_id']
    if (@user_id)
      if (!@user || !(@user.id == @user_id))
        @user = User.find(@user_id)
      end
      if @user && @user.partner?
        return whatschool = @user.school_id
      else
        return false
      end  
    else
      return false
    end
  end
end

Rails.application.routes.draw do
  constraints(AdminConstraint.new) do
    root 'admins#dashboard'
  end
  constraints(TeacherConstraint.new) do
    root 'lessons#new'
  end
  constraints(PartnerConstraint.new) do
    root 'partners#index'
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
  post '/users/change_view'
  post '/teachers/change_table'
  post '/lessons/sort'
  get '/schools/:id', to: 'schools#show'
  resources :teachers, only: [:new, :create, :update, :show, :destroy]
  resources :partners, only: [:index, :new, :create, :update, :destroy]
  resources :schools, only: [:new, :create, :update, :show, :destroy]
  resources :dateviews, only: [:update]

end
