class AdminConstraint
  def matches?(request)
    @user_id = request.session['user_id']
    if (@user_id)
      if (!@user || !(@user.id == @user_id))
        @user = User.find_by(id: @user_id)
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
        @user = User.find_by(id: @user_id)
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
        @user = User.find_by(id: @user_id)
      end
      return @user && @user.partner?
    else
      return false
    end
  end
end

Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  constraints(AdminConstraint.new) do
    root 'admins#dashboard'
  end
  constraints(TeacherConstraint.new) do
    root 'lessons#new_single'
  end
  constraints(PartnerConstraint.new) do
    root 'partners#school'
  end
  root 'sessions#new'

  get '/lessons/new-single'
  get '/lessons/checkout'
  post  '/lessons/checkout', to: 'lessons#finishCheckout'
  patch '/lessons/checkout', to: 'lessons#finishCheckout'
  get '/group_lessons/checkout'
  post  '/group_lessons/checkout', to: 'group_lessons#finishCheckout'
  patch  '/group_lessons/checkout', to: 'group_lessons#finishCheckout'
  get '/admins/new'
  get '/admins/dashboard'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  post '/sessions/change_view'
  post '/teachers/change_table'
  post '/lessons/sort'
  get '/partners/school'
  resources :lessons, only: [:index, :new, :create, :update, :destroy]
  resources :group_lessons, only: [:index, :new, :create, :update, :destroy]
  resources :teachers, only: [:index, :create, :update, :show, :destroy]
  resources :partners, only: [:index, :new, :create, :update, :destroy]
  resources :admins, only: [:index, :create, :update, :destroy]
  resources :schools, only: [:index, :create, :update, :show, :destroy]
  resources :students, only: [:index, :create, :update, :show, :destroy]
  resources :dateviews, only: [:create]
  resources :password_resets, only: [:new, :create, :edit, :update]

  get '/schools/:id', to: 'schools#show' # for partners to view

end
