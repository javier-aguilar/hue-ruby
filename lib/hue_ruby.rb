require "net/http"
require "json"
require "pry"

class HueRuby
  def self.connect
    uri = URI.parse("#{bridge.ip}/api")

    header = {'Content-Type': 'text/json'}
    body = { devicetype: "ruby", generateclientkey: true }

    # Create the HTTP objects
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = body.to_json

    # Send the request
    response = JSON(http.request(request).body)[0]
    
    if response["error"]
      raise ArgumentError, response["error"]["description"] 
    end

  end
end
