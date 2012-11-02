require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'minitest/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'restful_voyage'

class MiniTest::Unit::TestCase
  include Voyager
  
  def default_connection(app_config = nil)
    unless app_config
      app_config_filename ||= File.join(File.dirname(__FILE__), '..', 'config', 'app_config.yml')
      raise ArgumentError.new("Config file #{app_config_filename} not found") unless File.exists?(app_config_filename)
      app_config = YAML.load_file(app_config_filename)['voyager_connection']
    end

    Voyager::Connection.new(app_config)
  end

end

MiniTest::Unit.autorun
