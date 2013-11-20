Gem::Specification.new do |s|
  s.name = "wellesley-schedule-scraper"
  s.version = "0.1"
  s.date = "2013-11-19"
  s.authors = ["Al Wold"]
  s.email = "alwold@alwold.com"
  s.summary = "Scrapes schedule data for Wellesley"
  s.files = ["lib/wellesley_schedule_scraper.rb", "lib/wellesley_class_info.rb"]
  s.add_runtime_dependency "nokogiri"
end