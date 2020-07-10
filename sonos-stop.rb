require 'rubygems'
require 'net/http'
require 'cobravsmongoose'


def getURL(path)
	host = '192.168.57.124'
    "http://#{host}:1400#{path}"
end



def stopPlaying()
	path = path = "/MediaRenderer/AVTransport/Control"
    
	uri = URI(getURL(path))

	
	req = Net::HTTP::Post.new(getURL(path))
	req['SOAPAction'] = "urn:schemas-upnp-org:service:AVTransport:1#Stop"
	req['Content-type'] = 'text/xml; charset=utf8'
	req.body = '<?xml version="1.0" encoding="utf-8"?><s:Envelope s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><ns0:Stop xmlns:ns0="urn:schemas-upnp-org:service:AVTransport:1"><InstanceID>0</InstanceID></ns0:Stop></s:Body></s:Envelope>'
	
	
	res = Net::HTTP.start('192.168.86.105', 1400) {|http|
	
	  res = http.request(req)
	  }
end

msg = stopPlaying()