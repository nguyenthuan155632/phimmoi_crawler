require 'rubygems'
require 'open-uri'    

class FilmListController < ApplicationController
  def index
  end

  # API
  def get_all_films
    render json: FilmList.all.to_json
  end

  def get_specified_films
    f_type = params[:film_type]
    f_offset = params[:offset]
    f_limit= params[:limit]
    f = FilmList.where(film_type: f_type).order(id: :desc).limit(f_limit).offset(f_offset)
    films = { films: [] }
    f.each do |fm|
      fi = [fm.title_vi, fm.title_en, fm.duration, fm.url, fm.image, fm.status, fm.id]
      films[:films] << fi
    end
    render json: films
  end

  def get_home_films
    film_type = params[:film_type]
    limit = params[:limit]
    render json: FilmList.where(film_type: film_type).limit(limit)
  end

  def get_detail_film
    id = params[:id]
    render json: Film.where(film_list_id: id).first
  end

end
