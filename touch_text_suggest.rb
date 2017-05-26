require 'net/http'
require 'json'

seed = "Life is Good."

def get_suggestions(seed)

  params = Hash.new
  params.store("apikey", ENV['TEXT_SUGGEST_API_KEY'])
  params.store("previous_description", seed)

  uri = URI.parse('https://api.a3rt.recruit-tech.co.jp/text_suggest/v1/predict')
  uri.query = URI.encode_www_form(params)

  begin
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.get(uri.request_uri)
    end

    if not response.is_a? Net::HTTPSuccess
      return nil
    end
  rescue
    return nil
  end

  return response.body
end

20.times do
  puts seed
  response = get_suggestions(seed)

  if response.nil?
    exit
  end

  json = JSON::parse(response)

  if not json["message"] == "ok"
    exit
  end

  seed = json["suggestion"].sample
  sleep 1
end

