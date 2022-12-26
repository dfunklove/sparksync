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
    root 'courses#index'
  end
  constraints(PartnerConstraint.new) do
    root 'partners#school'
  end
  root 'sessions#new'

  get '/admins/dashboard'
  post '/courses/clone/:id', to: 'courses#clone'
  post '/courses/teach/:id', to: 'courses#teach'
  get  '/courses/teach/:id', to: 'courses#teach'
  get '/group_lessons/checkout'
  post  '/group_lessons/checkout', to: 'group_lessons#finishCheckout'
  patch  '/group_lessons/checkout', to: 'group_lessons#finishCheckout'
  post '/group_lessons/addStudent'
  get '/lessons/checkout'
  post  '/lessons/checkout', to: 'lessons#finishCheckout'
  patch '/lessons/checkout', to: 'lessons#finishCheckout'
  post '/lessons/sort'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get '/partners/school'
  post '/sessions/change_view'
  post '/students/search'
  post '/teachers/change_table'
  resources :courses
  resources :lessons, only: [:index, :new, :create, :update, :destroy]
  resources :group_lessons, only: [:index, :new, :create, :update, :destroy]
  resources :teachers, only: [:index, :create, :update, :show, :destroy]
  resources :partners, only: [:index, :new, :create, :update, :destroy]
  resources :admins, only: [:index, :new, :create, :update, :destroy]
  resources :schools, only: [:index, :create, :update, :show, :destroy]
  resources :students, only: [:index, :create, :update, :show, :destroy]
  resources :password_resets, only: [:new, :create, :edit, :update]
end
