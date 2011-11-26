#! /usr/bin/env ruby
ENV['RACK_ENV'] ||= 'production'

require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require

BASE_PATH = ENV['BASE_PATH'] || "./"

def render_index(context={})
  posts_html = ""
  Dir["#{BASE_PATH}/posts/*.yml"][0,10].each do |file|
    slug = File.basename(file, ".yml")
    post = get_post_content(slug, file)
    post[:url] = "/#{slug}"
    posts_html += render_raw_post(post, context)
  end
  render_page(posts_html, context)
end

def render_post(slug, context={})
  post_html = render_raw_post(get_post_content(slug), context)
  render_page(post_html, context.merge(:single_post => true))
end

def render_raw_post(post, context={})
  post.content = RDiscount.new(post.content).to_html  
  template = Liquid::Template.parse(File.read File.join(BASE_PATH, 'layouts', 'post.html.liquid'))
  template.render Hashie::Mash.new(context.merge(post.to_hash))
end

def get_post_content(slug, path=nil)
  path ||= File.join(BASE_PATH, 'posts', slug) + ".yml"
  post_data = Hashie::Mash.new YAML.load_file(path)
  post_data['content'] = File.read(path).sub /---.*---\n/m, ''
  post_data
end

def render_page(content, context={})
  layout = Liquid::Template.parse(File.read File.join(BASE_PATH, 'layouts', 'page.html.liquid'))
  layout.render Hashie::Mash.new context.merge(:content => content)
end

def search_form
  '<form action="/search" method="get"><input class="search" type="text" name="q"/></form>'
end

def basic_metadata
  {
    :root_path => '/',
    :search_form => search_form    
  }
end

def default_metadata
  hash = {
    :author => { :name => "Author Name", :email => "author@example.com" }, 
    :created_at => Time.now, 
    :modified_at => Time.now,
    :previous_page => '#',
    :next_page => '#',
  }
  hash['gravatar'] = "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(hash[:author][:email])}"
  hash.merge(basic_metadata)
end

get '/' do
  render_index default_metadata
end

get '/search' do
  render_page '', basic_metadata.merge({ :no_results => true, :query => params[:q] || 'some search query' })
end

get '/:slug' do
  render_post params[:slug], default_metadata
end