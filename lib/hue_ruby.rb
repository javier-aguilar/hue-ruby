require "net/http"
require "json"
require "pry"

class HueRuby
  def self.get_bridge_ip_address
    uri = URI("https://discovery.meethue.com/")
    response = Net::HTTP.get(uri)
    
    ip_address = JSON.parse(response)[0]["internalipaddress"]
    "http://#{ip_address}"
  end
  
  def self.connect
    uri = URI.parse("#{get_bridge_ip_address}/api")

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

  def self.get_lights
    uri = URI.parse("#{get_bridge_ip_address}/api/#{username}/lights")

    header = {
      'Content-Type': 'text/json',
      'hue-application-key': app_key
    }

    # Create the HTTP objects
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri, header)

    # Send the request
    response = http.request(request)
    # print JSON.parse(response.body)

    if response["error"]
      raise ArgumentError, response["error"]["description"] 
    end
  end


end
