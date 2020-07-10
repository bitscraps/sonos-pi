require 'rubygems'
require 'net/http'
require 'cobravsmongoose'
require 'sinatra'
require 'xkcd'


def wrapInEnvelope(body)
	"<?xml version=\"1.0\" encoding=\"utf-8\"?>
    <s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">
      <s:Body>#{body}</s:Body>
    </s:Envelope>"
end

def getURL(path)
	host = '192.168.86.105'
    "http://#{host}:1400#{path}"
end

def makeRequest(path, action, body, response)
	wrappedBody = wrapInEnvelope(body)
	
	uri = URI(getURL(path))

	
	req = Net::HTTP::Post.new(getURL(path))
	req['SOAPAction'] = action
	req['Content-type'] = 'text/xml; charset=utf8'
	req.body = wrappedBody
	
	
	res = Net::HTTP.start('192.168.86.105', 1400) {|http|
	  puts 'requesting'
	  res = http.request(req)
	  #puts res
	  
	  
	  
	  album = res.body
	  album = album.gsub(/.*?&lt;upnp:album&gt;/, '')
	  album = album.gsub(/&lt;\/upnp:album&gt;.*/, '')
	  	  album = album.gsub(/\&apos;/, "'")
	   album = album.gsub(/\&amp;/, "&")
	  
	  
	  
	  artist = res.body
	  artist = artist.gsub(/.*?&lt;dc:creator&gt;/, '')
	  artist = artist.gsub(/&lt;\/dc:creator&gt;.*/, '')
	  	  artist = artist.gsub(/\&apos;/, "'")
	   artist = artist.gsub(/\&amp;/, "&")
	  
	  url = res.body
	  url = url.gsub(/.*?&lt;upnp:albumArtURI&gt;/, '')
	  url = url.gsub(/&lt;\/upnp:albumArtURI&gt;.*/, '')
	  url = url.gsub(/&amp;amp;/, '&')
	  url = getURL(url)

	  
	  
	  track = res.body	  
	  track = track.gsub(/.*?&lt;dc:title&gt;/, '')
	  track = track.gsub(/&lt;\/dc:title.*/, '')
	  track = track.gsub(/\&apos;/, "'")
	   track = track.gsub(/\&amp;/, "&")
	  
	   puts "{\"album\": \"#{album}\", \"artist\": \"#{artist}\", \"track\": \"#{track}\", \"url\": \"#{url}\"} "
	  return "{\"album\": \"#{album}\", \"artist\": \"#{artist}\", \"track\": \"#{track}\", \"url\": \"#{url}\"} "
	 	}
	
	
end

def whatsPlaying()
	body = '<u:GetPositionInfo xmlns:u="urn:schemas-upnp-org:service:AVTransport:1">
      <InstanceID>0</InstanceID>
      <Channel>Master</Channel>
    </u:GetPositionInfo>'
    
    action = 'urn:schemas-upnp-org:service:AVTransport:1#GetPositionInfo'
    path = "/MediaRenderer/AVTransport/Control"
    
    obj = makeRequest(path, action, body, 'u:GetPositionInfoResponse')
    metadata = obj
    
end

get '/whatsPlaying' do
	whatsPlaying()
end

get '/sonos' do
	file = File.open("./sonos.html", "rb")
	contents = file.read
end

get '/index' do
	file = File.open("./index.html", "rb")
	contents = file.read
end

get '/quote' do
	file = File.open("./quote.html", "rb")
	contents = file.read

end

get '/xkcd' do
	temp = XKCD.img
	alt = temp.gsub(/.* :/, '')
	img = temp.gsub(/: .*?/, '')
	img = img.gsub(/http:.*/, '')
	
	"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Strict//EN\" 
\"http://www.w3.org/TR/html4/strict.dtd\"><html style='height:100%;overflow:hidden'><body style='height:100%;'><center style=\"height:700px;width:1200px;display:table-cell; vertical-align:middle;text-align:center;\"'><img style=\"max-height:90%;width:auto;vertical-align:middle;\" src=\"#{alt}\"><br/></center></body></html>"
end

get '/jquery.js' do
	file = File.open("./jquery.js", "rb")
	contents = file.read
end

get '/stylesheet.css' do
	file = File.open("./stylesheet.css", "rb")
	contents = file.read
end

get '/background.jpg' do
	file = File.open("./background-blue-cropped.jpg", "rb")
	contents = file.read
end
