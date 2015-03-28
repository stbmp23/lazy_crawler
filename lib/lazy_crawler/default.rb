require 'lazy_crawler/version'

module LazyCrawler
  module Default
    USER_AGENT = 'LazyCrawler/' + LazyCrawler::VERSION
    TIMEOUT = 20
    MAX_RETRY = 0
  end
end
