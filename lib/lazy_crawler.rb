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
      Net::HTTP.start(uri.host, uri.port) do |http|
        http.get(uri.path)
      end
    end
  rescue Timeout::Error
    return "request timed out. url: #{url}, timeout: " + LazyCrawler.timeout
  rescue => e
    return e.message
  end
end

LazyCrawler.reset!
