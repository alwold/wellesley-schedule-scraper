require_relative 'wellesley_class_info'

class WellesleyScheduleScraper
  def get_class_info(term_code, crn)
    doc = fetch_info(term_code, crn)
    name = string_value(doc.xpath("//tr[th/b/text()='Title']/th")[1].text)
    schedule = string_value(doc.xpath("//tr[th/b/text()='Meeting Time(s)']/th")[1].text)
    return WellesleyClassInfo.new(name, schedule)
  end

  def get_class_status(term_code, course_abbrev, course_number, class_number)
    doc = fetch_info(term_code, course_abbrev, course_number, class_number)
    rows = doc.xpath("//table[tr/th/b/a[text()='Subject']]/tr[td]")
    rows.each do |row|
      cells = row.xpath("td")
      if cells[1].text.strip == class_number
    # name = string_value(doc.xpath("//tr[th/b/text()='Seats Available']/th")[1].text)
        open_seats = cells[10].text.split('/')[0].to_i
        if open_seats == 0
          return :closed
        else
          return :open
        end
      end
    end
    nil
  end

private
  def string_value(node)
    if node == nil
      nil
    else
      node.to_s.strip
    end
  end

  def fetch_info(term_code, crn)
    uri = URI("https://courses.wellesley.edu/display_single_course_cb.php?crn=#{crn}&semester=#{term_code}&skip_graphics=1&no_navs=1")
    req = Net::HTTP::Get.new(uri.request_uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    res = http.start do |http| 
      res = http.request(req)
    end
    doc = Nokogiri::HTML(res.body)
    return doc
  end

end
