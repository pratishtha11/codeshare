class Snippet < ApplicationRecord
  before_validation :generate_short_code, on: :create
  
  validates :code_content, presence: true
  validates :short_code, uniqueness: true
  validates :language, inclusion: { 
    in: %w[plaintext ruby javascript python java c cpp go rust html css sql json bash] 
  }
  
  LANGUAGES = %w[plaintext ruby javascript python java c cpp go rust html css sql json bash]
  
  def generate_short_code
    return if short_code.present?
    
    loop do
      self.short_code = SecureRandom.alphanumeric(8).downcase
      break unless Snippet.exists?(short_code: short_code)
    end
  end
  
  def expired?
    expires_at.present? && Time.current > expires_at
  end
  
  def increment_views!
    update(views_count: views_count + 1)
  end
  
  def host
    Rails.application.config.hosts.presence || 'localhost:3000'
  end
  
  def full_url
    Rails.application.routes.url_helpers.snippet_url(short_code, host: host)
  end
  
  def raw_url
    Rails.application.routes.url_helpers.snippet_raw_url(short_code, host: host)
  end
end
