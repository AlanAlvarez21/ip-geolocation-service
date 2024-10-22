class InputExtractorService
  require "resolv"

  class InvalidInputError < StandardError; end

  def initialize(input)
    @input = input
  end

  def call
    url = extract_url
    input = extract_ip_or_return_nil(url)
        raise InvalidInputError, "Invalid IP or URL provided" unless input

    [ input, url ]
  end

  private

  def extract_url
    valid_url?(@input) ? @input : nil
  end

  def extract_ip_or_return_nil(url)
    if url
      get_ip_from_url(url)
    else
      valid_ip?(@input) ? @input : nil
    end
  end

  def valid_ip?(input)
    !!(input =~ Resolv::IPv4::Regex || input =~ Resolv::IPv6::Regex)
  end

  def valid_url?(input)
    uri = URI.parse(input)
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  rescue URI::InvalidURIError
    false
  end

  def get_ip_from_url(url)
    uri = URI.parse(url)
    Resolv.getaddress(uri.host)
  rescue Resolv::ResolvError
    nil # Retorna nil si no se puede resolver la IP
  end
end
