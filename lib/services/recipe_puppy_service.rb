require 'net/http'
require 'uri'
require 'json'

class RecipePuppyService
  def search_for(query, items=10)
    if items == 10
      canonical_search_for(query)
    else
      results = []
      body = nil
      pages = items / 10
      pages.times do |page|
        body = canonical_search_for(query, page + 1)
        results += body['results'] if body['results'].present?
      end
      body['results'] = results
      body
    end
  end

  def canonical_search_for(query, page=1)
    path = URI('/api')
    path.query = URI.encode_www_form({q: query, p: page})
    request = Net::HTTP::Get.new(path.to_s)
    request.add_field('Accept', 'application/json')
    begin
      response = remote_connection.request(request)
    rescue Timeout::Error => e
      return {'error' => 'timeout'}
    end
    parse_body(response.body)
  end

  private

  def remote_connection
    @_remote_address ||= begin
      uri = URI.parse(Settings.recipe_puppy_uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http
    end
  end

  def parse_body(body)
    begin
      body = JSON.parse(body)
      return body
    rescue Exception => e
      return {'error' => 'parsing_error'}
    end
  end
end
