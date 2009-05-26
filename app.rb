require 'rubygems'
require 'sinatra'
require 'haml'
require 'hpricot'
require 'open-uri'

helpers do

  def scrape_weather
    cities = {}
    open('http://www.bom.gov.au') do |f|
      doc = Hpricot(f.read)
      elements = (doc/'#pad table:nth-child(4)')
      (elements/'tr').each do |e|
        city  = (e/'a').html.downcase
        cities[city] = (e/'td:nth-child(3)').html unless city.size == 0
      end
    end
    cities
  end

  def nav(cities)
    menu = '<ul>'
    cities.each do |c,r|
      menu << "<li><a href=\"#{c}\">#{c}<a></li>"
    end
    menu << "</ul>"
  end

end

get '/' do
  redirect '/sydney'
end

get '/:name' do
  city = params[:name]
  cities = scrape_weather
  rain = cities[city]
  rain =~ /(\d+\.\d+)/
  if $1.to_f > 0.0
    @big = 'FUCK YES'
  else
    @big = 'HELL NO'
  end
  @small = city + ' ' + rain + ' since 9 a.m.<br>a <a href="http://bivou.ac">bivou.ac</a> service'
  @nav = nav cities
  haml :index, :options => {:format => :html5,
    :attr_wrapper => '"'}
end

__END__

@@ index
%div
  %h1= @big
  %p= @small
  = @nav

@@ layout
!!!
%html{:lang => "en-au"}
  %head
    %meta{:charset =>"UTF-8"}
    %title Hey, Is it Raining Today?
    %style{:type => "text/css", :media => "screen"}
      div {font: 700 1em helvetica,"helvetica neue", arial, sans-serif; margin: 0; padding: 220px 0 0 0; text-align: center;}
      h1 {font-size: 160px; padding: 0;margin: 0;}
      ul {list-style-type: none; font-size: 0.5em}
      li {display: inline; padding: 2px;}
  %body
    = yield
