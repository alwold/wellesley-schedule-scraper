require 'net/http'
require 'nokogiri'
require 'class_info'

module WellesleySpecHelpers
  def get_current_term
    doc = get_doc("https://courses.wellesley.edu/")
    doc.xpath("//select[@id='semester']/option/@value").each do |match|
      # try to match a fall/spring first
      if match.value.end_with?('02') || match.value.end_with?('09')
        return match.value
      end
    end
    # otherwise just use the first
    doc.xpath("//select[@id='semester']/option[position()=1]/@value")[0].value
  end

  def get_class(term, status)
    doc = get_schedule(term)
    course_rows = doc.xpath("//table[thead/tr/th/text()='CRN']/tbody/tr")
    course_rows.each do |row|
      cells = row.xpath("th")
      available_seats = cells[4].text.split("/")[0].to_i
      if (status == :open && available_seats != 0) || (status == :closed && available_seats == 0)
        course = ClassInfo.new
        course.crn = cells[0].text
        course.term = term
        return course
      end
    end
    nil
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

  def get_schedule(semester)
    uri = URI('https://courses.wellesley.edu/')
    req = Net::HTTP::Post.new(uri.request_uri)
    req.set_form_data('semester' => semester)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    res = http.start do |http|
      res = http.request(req)
    end
    Nokogiri::HTML(res.body)
  end
end

