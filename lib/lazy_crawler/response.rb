module LazyCrawler
  class Response
    attr_reader :result, :error, :code, :body

    def initialize(params = {})
      @result = (params[:error]) ? false : true
      @error = params[:error]
      @code, @body = nil

      if params[:response]
        @code = res.code
        @body = res.body
      end
    end
  end
end
