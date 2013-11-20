require 'net/http'
require 'nokogiri'

module WellesleySpecHelpers
  def get_current_term
    doc = get_doc("https://courses.wellesley.edu/")
    doc.xpath("//select[@id='semester']/option[position()=1]/@value")[0].value
  end

  def get_doc(url)
    uri = URI(url)
    req = Net::HTTP::Get.new(uri.request_uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    res = http.start do |http| 
      res = http.request(req)
    end
    Nokogiri::HTML(res.body)
  end
end

