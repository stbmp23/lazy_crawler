require 'lazy_crawler/default'

module LazyCrawler
  module Configurable
    attr_accessor :user_agent, :timeout, :max_retry

    def configure
      yield self
      validate_credentials!
      self
    end

    def reset!
      @user_agnet = LazyCrawler::Default::USER_AGENT
      @timeout = LazyCrawler::Default::TIMEOUT
      @max_retry = LazyCrawler::Default::MAX_RETRY
    end

    private

    def credentials
      {
        user_agent: String,
        timeout: Fixnum,
        max_retry: Fixnum,
      }
    end

    def validate_credentials!
      credentials.each do |key, klass|
        value = send("#{key}")
        unless value.is_a?(klass)
          next if value.nil?
          raise LazyCrawler::ConfigurationError \
                , "Invalid #{key} specified: #{value} must be a #{klass}"
        end
      end
    end
  end
end
