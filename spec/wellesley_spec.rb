require 'wellesley_schedule_scraper'
# require './class_info'
require 'wellesley_spec_helpers.rb'

RSpec.configure do |config|
  config.include WellesleySpecHelpers
end

describe WellesleySpecHelpers do
  it "can figure out the current term" do
    expect(get_current_term).to eq('201402')
  end
  it "can get an open class" do
    expect(get_class(:open).name).to eq('Intro to Black Experience')
  end
  it "can get a closed class" do
    expect(get_class(:closed).name).to eq('Medical Anthro:Comparative Std')
  end
  it "can load info about an open class" do
    scraper = WellesleyScheduleScraper.new
    info = scraper.get_class_info('201402', '22131')
    expect(info.name).to eq('First-Year Seminar: Reading/Writing Short Fiction')
    expect(info.schedule).to eq('TF - 01:30 pm - 02:40 pm Loc:')
  end
end
