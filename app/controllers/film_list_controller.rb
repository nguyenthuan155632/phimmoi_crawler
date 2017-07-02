require 'rubygems'
require 'open-uri'    

class FilmListController < ApplicationController
  def index

    update_detail_film

    # FilmList.all.each do |f|
    #   insert_detail_film(f.id, f.url, f.title_vi, f.title_en, f.image)
    # end

    # Film.all.each do |f|
    #   if f.f_trailer.include?("imdb")
    #     iframe = get_film_from_imdb_web(f.f_trailer)
    #     f.update(f_trailer: iframe)
    #   end
    #   if f.f_trailer.include?("youtube")
    #     youtube = get_film_from_youtube(f.f_trailer)
    #     f.update(f_trailer: youtube)
    #   end
    # end
  end

  def crawler_film_popular
    FilmList.where(film_type: "de-xuat").delete_all
    doc = Nokogiri::HTML(open("http://phimmoi.net/"))
    doc.css('ul#movie-carousel-top li').each do |li|
      f_status = li.css('.movie-carousel-top-item-meta span.ribbon').inner_html
      f_title_vi = li.css('.movie-carousel-top-item-meta .movie-name-1').inner_html
      f_title_en = li.css('.movie-carousel-top-item-meta .movie-name-2').inner_html
      f_url = "http://www.phimmoi.net/" + li.css('a')[0]["href"]
      
      x = li.css('.movie-carousel-top-item')[0]["style"].index("http")
      y = li.css('.movie-carousel-top-item')[0]["style"].index(")") - 1
      f_image = li.css('.movie-carousel-top-item')[0]["style"][x..y]

      f_list = FilmList.new(status: f_status, title_vi: f_title_vi, title_en: f_title_en, image: f_image, url: f_url, film_type: "de-xuat", full_type: "Phim đề xuất")
      f_list.save!
      insert_detail_film(f_list.id, f_url, f_title_vi, f_title_en, f_image)
    end
  end

  def crawler_film_collection pages
    films = [
          { film_type: "phim-chieu-rap", full_type: "Phim chiếu rạp" },
          { film_type: "phim-le", full_type: "Phim lẻ" },
          { film_type: "phim-bo", full_type: "Phim bộ" }
        ]
    films.each do |f|
      url = "http://www.phimmoi.net/" + f[:film_type] + "/"
      get_films(url, pages, f[:film_type], f[:full_type])
    end
  end

  def crawler_film_countries pages
    films = [
          { film_type: "vn", full_type: "Việt Nam" },
          { film_type: "cn", full_type: "Trung Quốc" },
          { film_type: "us", full_type: "Mỹ" },
          { film_type: "kr", full_type: "Hàn Quốc" },
          { film_type: "jp", full_type: "Nhật Bản" },
          { film_type: "hk", full_type: "Hồng Kông" },
          { film_type: "in", full_type: "Ấn Độ" },
          { film_type: "th", full_type: "Thái" },
          { film_type: "fr", full_type: "Pháp" },
          { film_type: "tw", full_type: "Đài Loan" },
          { film_type: "au", full_type: "Úc" },
          { film_type: "uk", full_type: "Anh" },
          { film_type: "ca", full_type: "Canada" }
        ]
    films.each do |f|
      url = "http://www.phimmoi.net/quoc-gia/" + f[:film_type] + "/"
      get_films(url, pages, f[:film_type], f[:full_type])
    end
  end

  def crawler_film_categories pages
    films = [
          { film_type: "phim-chien-tranh", full_type: "Phim chiến tranh" }, 
          { film_type: "phim-hinh-su", full_type: "Phim hình sự" },
          { film_type: "phim-hanh-dong", full_type: "Phim hành động" },
          { film_type: "phim-vien-tuong", full_type: "Phim viễn tưởng" },
          { film_type: "phim-phieu-luu", full_type: "Phim phiêu lưu" },
          { film_type: "phim-hai-huoc", full_type: "Phim võ thuật" },
          { film_type: "phim-kinh-di", full_type: "Phim kinh dị" },
          { film_type: "phim-hoi-hop-gay-can", full_type: "Phim gay cấn" },
          { film_type: "phim-bi-an-sieu-nhien", full_type: "Phim siêu nhiên" },
          { film_type: "phim-co-trang", full_type: "Phim cổ trang" },
          { film_type: "phim-than-thoai", full_type: "Phim thần thoại" },
          { film_type: "phim-tam-ly", full_type: "Phim tâm lý" },
          { film_type: "phim-tai-lieu", full_type: "Phim tài liệu" },
          { film_type: "phim-tinh-cam-lang-man", full_type: "Phim tình cảm" },
          { film_type: "phim-chinh-kich-drama", full_type: "Phim drama" },
          { film_type: "phim-the-thao-am-nhac", full_type: "Phim thể thao - âm nhạc" },
          { film_type: "phim-gia-dinh", full_type: "Phim gia đình" },
          { film_type: "phim-hoat-hinh", full_type: "Phim hoạt hình" }
        ]
    films.each do |f|
      url = "http://www.phimmoi.net/the-loai/" + f[:film_type] + "/"
      get_films(url, pages, f[:film_type], f[:full_type])
    end
  end

	def get_films url, pages, film_type, full_type
    (1..pages).reverse_each do |i|
      # byebug
      uri = url + "page-" + i.to_s + ".html"
      doc = Nokogiri::HTML(open(uri))
      doc.css('ul.list-movie li.movie-item').reverse_each do |li|
        f_status = li.css('.movie-meta span.ribbon').inner_html
        f_title_vi = li.css('.movie-meta .movie-title-1').inner_html
        f_title_en = li.css('.movie-meta .movie-title-2').inner_html
        f_duration = li.css('.movie-meta .movie-title-chap').inner_html
        f_url = "http://www.phimmoi.net/" + li.css('a.block-wrapper')[0]["href"]
        
        x = li.css('.movie-thumbnail')[0]["style"].index("http")
        y = li.css('.movie-thumbnail')[0]["style"].index(")") - 1
        f_image = li.css('.movie-thumbnail')[0]["style"][x..y]

        f_film_type = film_type
        f_full_type = full_type

        f_list = FilmList.new(status: f_status, title_vi: f_title_vi, title_en: f_title_en, image: f_image, duration: f_duration, url: f_url, film_type: f_film_type, full_type: f_full_type)
        unless FilmList.where(film_type: f_film_type, url: f_url).count > 0
          f_list.save!
          insert_detail_film(f_list.id, f_url, f_title_vi, f_title_en, f_image)
        end
      end
    end
	end

  def insert_detail_film film_list_id, url, title_vi, title_en, image
    doc = Nokogiri::HTML(open(url))
    f_title_vi = title_vi
    f_title_en = title_en
    f_image = image
    f_imdb = doc.css('.movie-info-box .movie-dd.imdb').inner_html
    f_status = doc.css('.movie-info-box .movie-dd.status').inner_html.strip

    country = ""
    doc.css('.movie-info-box .country').each { |c| country << c.inner_html + ", " }
    country.slice!(country.rindex(","))
    f_country = country.strip

    f_score = doc.css('.movie-info-box #star')[0]["data-score"]
    f_views = doc.css('.movie-info-box dl.movie-dl dd').last.inner_html.strip
    f_year = doc.css('.movie-info-box .title-year').inner_html.gsub('(', '').gsub(')', '').strip
    f_content = doc.css('#film-content').children.to_html

    iframe = (doc.css('#btn-film-trailer').blank?) ? "" : doc.css('#btn-film-trailer')[0]["data-videourl"]

    f_trailer = ""
    if iframe.include?("imdb")
      f_trailer = get_film_from_imdb_web(iframe)
    end
    if iframe.include?("youtube")
      f_trailer = get_film_from_youtube(iframe)
    end

    f_see_film = (doc.css('#btn-film-watch').blank?) ? "" : ("http://www.phimmoi.net/" + doc.css('#btn-film-watch')[0]["href"])
    film = Film.new(film_list_id: film_list_id,f_title_vi: f_title_vi, f_title_en: f_title_en, f_image: f_image, f_imdb: f_imdb, f_status: f_status, f_country: f_country, f_score: f_score, f_views: f_views, f_year: f_year, f_content: f_content, f_trailer: f_trailer, f_see_film: f_see_film)
    film.save!
  end

  def update_detail_film
    FilmList.offset(14477).each do |f|
      doc = Nokogiri::HTML(open(f.url))
      iframe = (doc.css('#btn-film-trailer').blank?) ? "" : doc.css('#btn-film-trailer')[0]["data-videourl"]
      if iframe.include?("youtube")
        f_trailer = get_film_from_youtube(iframe)
        Film.where(film_list_id: f.id).update(f_trailer: f_trailer)
      end
    end
  end

  def get_film_from_imdb_web url
    doc = Nokogiri::HTML(open(url))
    iframe = (doc.css('#video-player-container').blank?) ? url : doc.css("#video-player-container")[0]["src"]
    if iframe
      iframe.strip
    else
      url
    end
  end

  def get_film_from_youtube url
    url.gsub("watch?v=", "embed/")
  end

  # API
  def get_all_films
    render json: FilmList.all.to_json
  end

  def get_specified_films
    f_type = params[:film_type]
    f_offset = params[:offset]
    f_limit= params[:limit]
    films = FilmList.where(film_type: f_type).order(id: :desc).limit(f_limit).offset(f_offset).to_json
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
