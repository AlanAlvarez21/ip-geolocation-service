require "resolv"
require "httparty"

class GeolocationService
  def initialize(input)
    @input = input
  end

  def call
    input_extractor = InputExtractorService.new(@input)
    input, url = input_extractor.call

    response = HTTParty.get("http://api.ipstack.com/#{input}?access_key=#{ENV['IPSTACK_API_KEY']}")
    data = response.parsed_response

    if response.success?
      data.merge("url" => url)
    else
      error_message = data["error"] ? data["error"]["info"] : "Unknown error"
      raise StandardError, "Failed to retrieve geolocation data: #{error_message}"
    end
  end
end
