require "uri"
require "net/http"
require "timeout"
require "lazy_crawler/version"
require "lazy_crawler/robots"
require "lazy_crawler/configurable"
require "lazy_crawler/response"

module LazyCrawler
  class LazyCrawlerError < StandardError; end
  class ConfigurationError < LazyCrawlerError; end

  class << self
    include LazyCrawler::Configurable
  end

  def self.http_get(url)
    uri = URI.parse(url)
    res = self.net_http(uri, "#{uri.path}?#{uri.query}")

    p res

    if res.is_a?(Net::HTTPRedirection) || res.is_a?(Net::HTTPMovedPermanently)
      loc = res.fetch 'location'
      p loc
      if /http/ =~ loc
        uri = URI.parse(loc) if loc =~ /http/
        loc = "#{uri.path}?#{uri.query}"
      end

      res = self.net_http(uri, loc)
    end

    LazyCrawler::Response.new(response: res)
  rescue Timeout::Error
    LazyCrawler::Response.new(error: "request timed out. url: #{url}, timeout: #{LazyCrawler.timeout}")
  rescue => e
    LazyCrawler::Response.new(error: e.message)
  end

  def self.net_http(uri, location)
    Net::HTTP.start(uri.host, uri.port) do |http|
      http.open_timeout = LazyCrawler.timeout
      http.read_timeout = LazyCrawler.timeout
      http.request(Net::HTTP::Get.new(location))
    end
  end
end

LazyCrawler.reset!
