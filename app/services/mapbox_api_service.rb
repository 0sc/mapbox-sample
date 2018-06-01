require 'open-uri'

class MapboxApiService
  TYPES = ['poi'].freeze
  ACCESS_TOKEN = ENV['MAPBOX_API_KEY']
  BASE_URL = 'https://api.mapbox.com/geocoding/v5/mapbox.places/museum.json'.freeze
  POSTCODE_REGEX = /^postcode\.\d+$/

  attr_reader :lat, :lng

  def initialize(lat:, lng:)
    @lat = lat
    @lng = lng
  end

  # TODO: handle api request errors
  def perform
    url = build_request_url
    req = open(url).read
    response_body = JSON.parse(req)
    build_museum_objects_from_response(response_body['features'])
  end

  private

  def build_request_url
    BASE_URL + '?&' \
      "proximity=#{lat},#{lng}" + '&' \
    "types=#{TYPES.join('&')}" + '&' \
    'limit=10' + '&' \
    "access_token=#{ACCESS_TOKEN}"
  end

  def build_museum_objects_from_response(museum_objects)
    museum_objects.map do |museum_object|
      build_museum(museum_object)
    end
  end

  def build_museum(museum_details)
    Museum.new(
      name: museum_details['text'],
      postcode: fetch_postcode_from_context(museum_details['context'])
    )
  end

  def fetch_postcode_from_context(context)
    context.each do |ctx|
      next unless ctx['id'].match?(POSTCODE_REGEX)
      return ctx['text']
    end
    nil
  end
end
