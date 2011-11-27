ENV['RACK_ENV'] ||= 'production'

require 'rubygems'
require 'sinatra/base'
require 'hashie'
require 'liquid'
require 'rdiscount'
require 'jekyll'

BASE_PATH = ENV['BASE_PATH'] || "./"

class Server < Sinatra::Base
  
  configure do
    Liquid::Template.register_filter(Jekyll::Filters)
  end

  def render_index(context={}, options={})
    context[:posts] = []
    Dir["#{BASE_PATH}/posts/*.yml"][0,10].each do |file|
      slug = File.basename(file, ".yml")
      post = get_post_content(slug, file)
      post.url = "/#{slug}"
      post.content = RDiscount.new(post.content).to_html
      context[:posts] << post.to_hash
    end
    render_page(context, options)
  end

  def render_post(slug, context={})
    post = get_post_content(slug)
    post.content = RDiscount.new(post.content).to_html
    context[:posts] = [post.to_hash]
    context[:single_post] = true
    render_page(context)
  end

  def get_post_content(slug, path=nil)
    path ||= File.join("#{BASE_PATH}posts", slug) + ".yml"
    begin
      post_data = Hashie::Mash.new YAML.load_file(path)
      post_data.content = File.read(path).sub /---.*---\n/m, ''
      post_data.author = Hashie::Mash.new :name => "Author Name", :email => "author@example.com"
      post_data.gravatar = "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(post_data.author.email)}"
      post_data.created_at = Time.now
      post_data.modified_at = Time.now
      post_data
    rescue => e
      puts "!! Error loading #{path}"
      # raise e
      Hashie::Mash.new :content => "Error in #{slug}.yml: #{e.message}"
    end
  end

  def render_page(context, options={})
    layout = options[:layout] || 'index.html.liquid'
    layout = Liquid::Template.parse(File.read File.join(BASE_PATH, 'templates', layout))
    layout.render Hashie::Mash.new context
  end

  def search_form
    '<form action="/search" method="get"><input class="search" type="text" name="q"/></form>'
  end

  def basic_metadata
    Hashie::Mash.new({
      :root_path => request.url.match(/(^.*\/{2}[^\/]*)/)[1],
      :asset_path => '/assets',
      :search_form => search_form    
    })
  end

  def default_metadata
    hash = {
      :previous_page => '#',
      :next_page => '#',
    }
    hash.merge(basic_metadata)
  end

  get '/' do
    render_index default_metadata
  end

  get '/assets/*' do
    asset_path = params[:splat].join "/"
    send_file "#{BASE_PATH}/assets/#{asset_path}"
  end

  get '/search' do
    render_page '', basic_metadata.merge({ :no_results => true, :query => params[:q] || 'some search query' })
  end
  
  get '/atom.xml' do
    content_type 'application/atom+xml'
    render_index default_metadata, :layout => 'atom.xml.liquid'
  end

  get '/:slug' do
    render_post params[:slug], default_metadata
  end
end