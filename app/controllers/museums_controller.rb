class MuseumsController < ApplicationController
  # TODO: How do handle requests with missing params
  def index
    lat = params[:lat]
    lng = params[:lng]

    mapservice = MapboxApiService.new(lat: lat, lng: lng)
    museums = mapservice.perform

    render json: museums_by_postcode(museums)
  end

  private

  def museums_by_postcode(museums)
    result = {}

    museums.each do |museum|
      result[museum.postcode] ||= []
      result[museum.postcode] << museum.name
    end

    result
  end
end
