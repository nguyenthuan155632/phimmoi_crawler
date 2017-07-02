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
      fm.duration = "Đề xuất" if fm.duration.nil?
      fi = [fm.title_vi.to_s, fm.title_en.to_s, fm.duration.to_s, fm.url.to_s, fm.image.to_s, fm.status.to_s, fm.id.to_s]
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
    id = params[:id].to_i
    f = Film.where(film_list_id: id).first
    film = { film: [] }

    fi = [f.f_title_vi.to_s, f.f_title_en.to_s, f.f_imdb.to_s, f.f_image.to_s, f.f_status.to_s, f.f_country.to_s, f.f_score.to_s, f.f_views.to_s, f.f_year.to_s, f.f_content.to_s, f.f_trailer.to_s, f.f_see_film.to_s]
    film[:film] = fi

    render json: film
  end

end
