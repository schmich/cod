require 'tilt'
require 'RedCloth'

class NBRedClothTemplate < Tilt::RedClothTemplate
  include Middleman::CoreExtensions::FrontMatter::YamlAware
  
  def prepare
    super
    @engine.hard_breaks = false
  end
end
Tilt.register NBRedClothTemplate, 'textile'
Tilt.prefer NBRedClothTemplate

Slim::Engine.set_default_options :pretty => true

set :textile, :layout_engine => :slim

configure :build do
  set :http_prefix, "/cod/"
end