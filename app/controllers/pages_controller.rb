class PagesController < ApplicationController
  def index
    pages = Page.all
    render json: pages, status: :ok
  end

  def show
    page = Page.find(params[:id])
    render json: page, status: :ok
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def create
    html_page = fetch_page(params[:url]).to_s
    title = Nokogiri::HTML(html_page).css('title').first.text

    page = Page.new(title: title, body: sanitize(html_page), url: params[:url])

    if page.save
      render json: page, status: :created
    else
      render json: page.errors, status: :unprocessable_entity
    end
  end

  private

  def sanitize(html)
    Sanitize.document(html, allow_doctype: false, elements: %w[html h1 h2 h3 p])
  end

  def fetch_page(url)
    RestClient.get(url)
  end
end
