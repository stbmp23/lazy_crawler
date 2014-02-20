$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'lazy_crawler'

require 'simplecov'
SimpleCov.start

require 'rspec/autorun'
require 'webmock/rspec'

WebMock.disable_net_connect!

RSpec.configure do |config|
end

# web resource helper
def fixture(file)
  File.new(File.expand_path("./spec/fixtures/" + file))
end

