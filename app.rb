require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require 'open-uri'
require 'nokogiri'

get '/' do
  @links = Array.new
  @imgs = Hash.new
  url = 'http://lit.gahaku.tech/old/'
  html = open(url).read
  parsend_html = Nokogiri::HTML.parse(html,nil,'utf-8')
  i = 0
  parsend_html.css('ul.supporter-list').css('li').each do |node|
    anchor = node.css('a')
    temp = anchor.css('img')
    @links[i] = temp.attribute('alt').value
    temp.attribute('src').value = url + temp.attribute('src').value
    @imgs[@links[i]] = temp.to_html
    i = i +1
  end
  erb :index
end
