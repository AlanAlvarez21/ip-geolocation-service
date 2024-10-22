require "resolv"
require "httparty"

class GeolocationService
  class ServiceError < StandardError; end

  def initialize(input)
    @input = input
  end

  def call
    input_extractor = InputExtractorService.new(@input)
    input, url = input_extractor.call

    begin
      response = HTTParty.get("http://api.ipstack.com/#{input}?access_key=#{ENV['IPSTACK_API_KEY']}")
      data = response.parsed_response

      if response.success? && data_valid?(data)
        data.merge("url" => url)
      else
        error_message = data["error"] ? data["error"]["info"] : "Unknown error"
        raise ServiceError, "Failed to retrieve geolocation data: #{error_message}"
      end

    rescue SocketError, Errno::ECONNREFUSED => e
      raise ServiceError, "Network error: Unable to connect to the geolocation service - #{e.message}"
    rescue StandardError => e
      raise ServiceError, "Unexpected error: #{e.message}"
    end
  end

  private

  def data_valid?(data)
    data["ip"].present? && data["latitude"].present? && data["longitude"].present?
  end
end
