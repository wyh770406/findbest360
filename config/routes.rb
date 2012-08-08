Findbest360::Application.routes.draw do
  #get \"users\/show\"

  root :to => "home#index"
  match "/uploads/*path" => "gridfs#serve"
  #  match "/admin/login" => "admin#login"
  devise_for :admins

  resources :admin  

  devise_for :users,:controllers => { :sessions => "sessions" }
  resource :home
  resources :users, :only => :show
  resources :company_profiles
  resources :friend_links
  resources :recruits
  resources :contacts
  resources :brands
  resources :cooperations
  resources :question_advices
  resources :end_products do
    resources :products
  end
  resources :merchant_entries do
    collection do
      get 'download'
    end
  end
  resources :website_guides do
    collection do
      get 'most_used_website'
    end

    collection do
      post 'save_favorite_site'
    end
  end
  resources :groupbuy_sites do
    collection do 
      get 'resort'
      get 'price_sort'
    end
  end
  resources :promote_discounts
  resources :products do
    collection do
      post 'search'
      get 'search', :as => 'search'
      post 'detail'
      get 'detail'
      get 'autocomplete_keyword_word'
    end
    
    member do 
      get 'record'
    end

  end
  
  resources :brands, :only => [:index] do 
    member do
      post 'comments'
      get 'comments'
    end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:


  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  namespace :adminpanel do
    #     # Directs /admin/products/* to Admin::ProductsController
    #     # (app/controllers/admin/products_controller.rb)
    resources :top_products do
      resources :promote_discounts
      resources :keywords
      resources :middle_products do
        collection do
          get 'filter_middle_product'

        end

        resources :end_products do
          collection do
            get 'filter_end_product'

          end          
          resources :products do
            collection do
              post 'search'
            end
          end
        end



      end


    end

    resources :composite_sites

    resources :brands do

      member do
        get 'assign_top_cate'
        get 'assign'
        get 'remove'
      end
      collection do
        post 'search'
      end
      resources :brand_types do
        collection do
          get 'filter_brand_type'
          post 'search'
        end
      end
      resources :products
    end

    resources :merchants do
      member do
        get 'assign_top_cate'
        get 'assign'
        get 'remove'
      end
      collection do
        post 'search'
      end
      resources :products do
        collection do
          post 'search'
        end
      end
    end

    resources :tuangou_cates do
      resources :tuangou_sites
    end

    resources :company_profiles
    resources :friend_links
    resources :recruits
    resources :contacts
    resources :cooperations
    resources :merchant_entries
    resources :question_advices
  end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
