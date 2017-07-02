Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/film_list', to: 'film_list#index'
  # get '/film_list/get_films', to: 'film_list#get_films'
  # get '/film_list/crawler_film_categories/', to: 'film_list#crawler_film_categories'
  # get '/film_list/crawler_film_collection/', to: 'film_list#crawler_film_collection'
  # get '/film_list/crawler_film_countries/', to: 'film_list#crawler_film_countries'
  # get '/film_list/crawler_film_popular', to: 'film_list#crawler_film_popular'

  # API
  get '/film_list/get_all_films', to: 'film_list#get_all_films'
  get '/film_list/get_specified_films/:film_type/:offset/:limit', to: 'film_list#get_specified_films'
  get '/film_list/get_detail_film/:id', to: 'film_list#get_detail_film'
  get '/film_list/get_home_films/:film_type/:limit', to: 'film_list#get_home_films'
end
