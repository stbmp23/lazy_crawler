lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lazy_crawler'
require 'webmock'
include WebMock::API
WebMock.disable_net_connect!

url = "http://localhost/himitsu/"
text =<<EOD
User-agent: *
Allow: /abc
Disallow: /himitsu/
Disallow: /cgi-bin/
EOD

uri = URI.parse(url)

stub_request(:any, url).to_return(:body => "")
stub_request(:any, "http://"+uri.host+"/robots.txt").to_return(:body => text)

p LazyCrawler::Robots.allowed?(url)

