require "resolv"
require "httparty"

class GeolocationService
  API_URL = "http://api.ipstack.com/"

  def initialize(input)
    @input = input
  end

  def call
    ip_or_url = extract_ip_or_url(@input)
    raise StandardError, "Invalid IP or URL" unless ip_or_url

    fetch_geolocation_data(ip_or_url)
  end

  private

  # Extrae una IP o la resuelve desde una URL, validando ambas entradas
  def extract_ip_or_url(input)
    if valid_ip?(input)
      input
    elsif valid_url?(input)
      get_ip_from_url(input)
    else
      nil
    end
  end

  # Valida si el input es una IP válida (IPv4 o IPv6)
  def valid_ip?(input)
    !!(input =~ Resolv::IPv4::Regex || input =~ Resolv::IPv6::Regex)
  end

  # Valida si el input es una URL válida
  def valid_url?(input)
    uri = URI.parse(input)
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  rescue URI::InvalidURIError
    false
  end

  # Resuelve la IP desde una URL (host)
  def get_ip_from_url(url)
    uri = URI.parse(url)
    Resolv.getaddress(uri.host)
  rescue Resolv::ResolvError
    nil
  end

  # Realiza la solicitud HTTP a ipstack para obtener los datos de geolocalización
  def fetch_geolocation_data(ip)
    response = HTTParty.get("#{API_URL}#{ip}?access_key=ENV['IPSTACK_API_KEY']")

    handle_response(response)
  end

  # Manejo de la respuesta HTTP, levantando errores si falla
  def handle_response(response)
    if response.success?
      response.parsed_response
    else
      error_message = response.parsed_response["error"] ? response.parsed_response["error"]["info"] : "Unknown error"
      raise StandardError, "Failed to retrieve geolocation data: #{error_message}"
    end
  end
end
