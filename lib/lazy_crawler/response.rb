module LazyCrawler
  class Response
    attr_reader :result, :error, :code, :body, :response

    def initialize(params = {})
      @result = (params[:error]) ? false : true
      @error = params[:error]
      @code, @body, @response = nil

      if params[:response]
        @response = params[:response]
        @code = @response.code
        @body = @response.body
      end
    end
  end
end
