class SnippetsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :find_snippet, only: [:show, :raw]
  
  def new
    @snippet = Snippet.new
  end
  
  def create
    @snippet = Snippet.new(snippet_params)
    
    if @snippet.save
      render json: {
        success: true,
        short_code: @snippet.short_code,
        url: "/snippets/#{@snippet.short_code}",
        raw_url: "/raw/#{@snippet.short_code}"
      }, status: :created
    else
      render json: { 
        success: false, 
        errors: @snippet.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end
  
  def show
    if @snippet.expired?
      render file: "#{Rails.root}/public/404.html", status: :not_found
      return
    end
    
    @snippet.increment_views!
  end
  
  def raw
    if @snippet.expired?
      head :not_found
      return
    end
    
    @snippet.increment_views!
    render plain: @snippet.code_content, content_type: 'text/plain'
  end
  
  private
  
  def find_snippet
    @snippet = Snippet.find_by!(short_code: params[:short_code])
  rescue ActiveRecord::RecordNotFound
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end
  
  def snippet_params
    params.require(:snippet).permit(:code_content, :language, :title, :expires_at)
  end
end
