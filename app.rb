require 'rubygems'
require 'sinatra'
require 'haml'

get '/' do
  @big = 'FUCK YES'
  @small = ''
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
