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
        city  = (e/'a').html
        cities[city] = (e/'td:nth-child(3)').html unless city.size == 0
      end
    end
    cities
  end

end

get '/' do
  cities = scrape_weather
  rain = cities['Sydney']
  rain =~ /(\d+\.\d+)/
  raining = $1.to_i > 0.0
  if raining
    @big = 'FUCK YES'
  else
    @big = 'HELL NO'
  end
  @small = rain + ' since 9 a.m.'
  haml :index, :options => {:format => :html5,
                            :attr_wrapper => '"'}
end

__END__
  
@@ index
%div
  %h1= @big
  %p= @small

@@ layout
!!!
%html{:lang => "en-au"}
  %head
    %meta{:charset =>"UTF-8"}
    %title Hey, Is it Raining Today?
    %style{:type => "text/css", :media => "screen"}
      div {font: 700 1em helvetica,"helvetica neue", arial, sans-serif; margin: 0; padding: 220px 0 0 0; text-align: center;}
      h1 {font-size: 160px; padding: 0;margin: 0;}
  %body
    = yield
