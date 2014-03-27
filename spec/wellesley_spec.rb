require 'wellesley_schedule_scraper'
require 'wellesley_spec_helpers.rb'

RSpec.configure do |config|
  config.include WellesleySpecHelpers
end

describe WellesleySpecHelpers do
  it "can figure out the current term" do
    expect(get_current_term.length).to eq(6)
  end
  it "can get an open class" do
    scraper = WellesleyScheduleScraper.new
    open_class = get_class(get_current_term, :open)
    expect(scraper.get_class_status(open_class.term, open_class.crn)).to eq(:open)
  end
  it "can get a closed class" do
    scraper = WellesleyScheduleScraper.new
    closed_class = get_class(get_current_term, :closed)
    expect(scraper.get_class_status(closed_class.term, closed_class.crn)).to eq(:closed)
  end
  it "can load info about an open class" do
    scraper = WellesleyScheduleScraper.new
    info = scraper.get_class_info('201409', '13107')
    expect(info.name).to eq('The African American Literary Tradition')
    expect(info.schedule).to eq('T - 01:30 pm - 04:00 pm')
  end
  it "returns nil for non-existent class" do
    scraper = WellesleyScheduleScraper.new
    info = scraper.get_class_info(get_current_term, '999999')
    expect(info).to be_nil
    status = scraper.get_class_status(get_current_term, '999999')
    expect(status).to be_nil
  end
end
