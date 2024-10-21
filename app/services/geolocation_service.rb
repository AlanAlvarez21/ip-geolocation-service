require 'resolv'

class GeolocationService
    def initialize(input)
    @input = input
    end

    def call
    ip = extract_ip(@input)
    raise StandardError, "Invalid IP or URL" unless ip

      response = HTTParty.get("http://api.ipstack.com/#{ip}?access_key=#{ENV['IPSTACK_API_KEY']}")

    if response.success?
        {
        ip: ip,
        city: response['city'],
        country: response['country_name'],
        latitude: response['latitude'],
        longitude: response['longitude'],
        provider: 'ipstack'
        }
    else
      raise StandardError, "Failed to retrieve geolocation data"
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
