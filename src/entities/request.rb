class Request
  attr_accessor :endpoint, :video, :request_number

  def initialize(video, endpoint, request_number)
    @endpoint = endpoint
    @video = video
    @request_number = request_number
  end

  def to_s
    "Request: Endpoint ID #{endpoint.id} Video ID #{video.id} Requests: #{request_number}"
  end
end
