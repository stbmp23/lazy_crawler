require "uri"
require "net/http"
require "timeout"
require "lazy_crawler/version"
require "lazy_crawler/robots"
require "lazy_crawler/configurable"

module LazyCrawler
  class LazyCrawlerError < StandardError; end
  class ConfigurationError < LazyCrawlerError; end

  class << self
    include LazyCrawler::Configurable
  end

  def self.http_get(url)
    uri = URI.parse(url)
    Timeout::timeout(LazyCrawler.timeout) do
      res = self.net_http(uri, "#{uri.path}?#{uri.query}")

      if Net::HTTPRedirection
        loc = res.fetch 'location'
        res = self.net_http(uri, loc)
      end

      res
    end
  rescue Timeout::Error
    return "request timed out. url: #{url}, timeout: #{LazyCrawler.timeout}"
  rescue => e
    return e.message
  end

  def self.net_http(uri, location)
    Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(Net::HTTP::Get.new(location))
    end
  end
end

LazyCrawler.reset!
