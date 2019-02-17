require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require 'open-uri'
require 'nokogiri'

get '/' do
  @supporter_links = Array.new
  @supporter_imgs = Hash.new
  @supporter_name = Hash.new
  @school_links = Array.new
  @school_name = Hash.new
  url = 'http://lit.gahaku.tech/old/'
  html = open(url).read
  parsend_html = Nokogiri::HTML.parse(html,nil,'utf-8')
  i = 0
  parsend_html.css('ul.supporter-list').css('li').each do |node|
    anchor = node.css('a')
    temp = anchor.css('img')
    @supporter_links[i] = anchor.attribute('href').value.gsub(/https:\/\/web.archive.org\/web\/20170603211131\//,"")
    @supporter_name[@supporter_links[i]] = temp.attribute('alt').value
    temp.attribute('src').value = url + temp.attribute('src').value
    @supporter_imgs[@supporter_links[i]] = temp.to_html
    i = i +1
  end

  j = 0
  parsend_html.css('ul.school-list').css('li').each do |node|
    anchor = node.css('a')
    temp = anchor.css('h3')
    @school_links[j] = anchor.attribute('href').value.gsub(/https:\/\/web.archive.org\/web\/20170603211131\//,"")
    @school_name[@school_links[j]] = temp.text
    j = j + 1
  end
  erb :index
end
