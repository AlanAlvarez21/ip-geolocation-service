require "resolv"

class GeolocationService
  def initialize(input)
    @input = input
  end

  def call
    input = extract_ip(@input)
    raise StandardError, "Invalid IP or URL" unless input

      response = HTTParty.get("http://api.ipstack.com/#{ip}?access_key=#{ENV['IPSTACK_API_KEY']}")

    data = response.parsed_response
    if response.success?
      data
    else
      error_message = data["error"] ? data["error"]["info"] : "Unknown error"
      raise StandardError, "Failed to retrieve geolocation data: #{error_message}"
    end
  end

    private

    # Método para extraer IP, ya sea directamente o desde una URL
    def extract_ip(input)
    if valid_ip?(input)
        input
    elsif valid_url?(input)
        get_ip_from_url(input)
    end
    end

    # Verifica si el input es una IP válida
    def valid_ip?(input)
     !!(input =~ Resolv::IPv4::Regex || input =~ Resolv::IPv6::Regex)
    end

    # Verifica si el input es una URL válida
    def valid_url?(input)
      uri = URI.parse(input)
      uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
    rescue URI::InvalidURIError
      false
    end

    # Resuelve la IP desde una URL
    def get_ip_from_url(url)
      uri = URI.parse(url)
      Resolv.getaddress(uri.host)
    rescue Resolv::ResolvError
      nil
    end
end
