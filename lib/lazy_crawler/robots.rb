module LazyCrawler
  class Robots
    class << self
      def allowed?(url)
        host = URI.parse(url).host
        robots(host).allow?(url)
      end

      def robots(host)
        @robots ||= {}
        @robots[host] = LazyCrawler::Robots.new(host) unless @robots[host]
        @robots[host]
      end
    end

    def initialize(host)
      robots_txt = LazyCrawler.http_get("http://" + host + "/robots.txt")
      analyze(robots_txt)
    end

    def allow?(url)
      url_path = URI.parse(url).path
      @allows.each do |pattern|
        return true if pattern == "/" || url_path =~ to_regexp(pattern)
      end

      @disallows.each do |pattern|
        return false if pattern == "/" || url_path =~ to_regexp(pattern)
      end

      return true
    end

    def analyze(robots_txt)
      @allows = []
      @disallows = []

      return unless robots_txt.class == Net::HTTPOK

      is_target = false
      robots_txt.body.each_line do |line|
        is_target = analyze_line?(line) if line =~ /agent/ 
        
        if is_target
          case line
          when /Allow/
            @allows << robots_value(line)
          when /Disallow/
            @disallows << robots_value(line)
          end
        end
      end
    end

    def analyze_line?(line)
      line =~ /\*/ || line =~ /#{LazyCrawler.user_agent}/
    end

    def robots_value(line)
      line.match(/^.+:.?(.+)$/)[1].to_s
    end

    def to_regexp(pattern)
      return /not-match-anything-allow-and-disallow/ unless pattern
      pattern = Regexp.escape(pattern)
      pattern.gsub!(Regexp.escape("*"), ".*")
      Regexp.compile("^#{pattern}")
    end
  end
end
