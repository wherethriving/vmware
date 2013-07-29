#!/usr/bin/ruby 

require 'cfoundry'
require 'sinatra'
require 'yaml'


get '/' do
	 "Begin my first cfoundry testing!"

home = ENV['HOME']

endpoint = 'https://api.run.pivotal.io'
username = 'core.he416@gmail.com'
password = '82328718'

target = 'api.run.pivotal.io'

begin 
#	client = CFoundry::Client.get(target)
rescue CFoundry::TargetRefused
	"Target refused connection"
rescue CFoundry::InvalidTarget
	"Invalid target URI"
end

config = YAML.load File.read("#{home}/.cf/tokens.yml")
token = CFoundry::AuthToken.from_hash config[endpoint]

#get the client through URL(endpoint) and token gotten by reading local file
client = CFoundry::Client.get endpoint, token 
#puts "methods:"
#puts client.methods.grep // 

puts "target:\n"
puts client.target
#client = CFoundry::Client.new endpoint 
#client.login username, password

client.organizations
client.services.collect { |x| x.description }

puts "apps:\n"
puts client.apps
puts client.apps_by_name "caldecott"

#puts client.runtimes.collect { |x| x.name }

puts "successful"


app_test = client.apps_by_name "caldecott"
puts "show uris:\n"
puts app_test.methods
puts app_test.display
app_test.stopped!




app = client.app 
puts "app's methods:"
puts app.methods.grep //

app.name = "test_cfoundry"
app.total_instances = 1
app.memory = 512
#app.production = true
#app.framework = client.frameworks.select{ |x| x.name == 'sinatra' }.first 
#app.runtime = client.runtimes.select{ |x| x.name == 'ruby19' }.first
app.space = client.spaces.first


if app.name != "test_cfoundry"
	app.create!
	"Create #{app.name} successful!"
end

puts "delete #{app.name}?"
delete_flag = gets.chomp

#if delete_flag 
	"Delete #{app.name}!"
#end





end
