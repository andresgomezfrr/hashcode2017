class Request
  attr_accessor :endpoint, :video, :request_number

  def initialize(endpoint, video, request_number)
    @endpoint = endpoint
    @video = video
    @request_number = request_number
  end
end
