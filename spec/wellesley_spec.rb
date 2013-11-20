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
end
