require 'csv'
require 'capybara'
require 'nokogiri'
require 'pry'

Capybara.default_driver = :selenium_chrome_headless
Capybara.javascript_driver = :selenium_chrome_headless
Capybara.run_server = false # Switch off rack server
Capybara.app_host = "http://roman.cs.pusan.ac.kr"

browser = Capybara.current_session

rows = CSV.parse(File.read("100_mountains_korean.csv"), headers: true)

# data_arr = []
output = CSV.open("output.csv", "w")
output << ["Name", "Elevation(m)"]

rows.each do |row|
  browser.reset!
  browser.visit "/input_eng.aspx?"
  # browser.fill_in("inputText", with: "#{rows[0]["산이름"]}")
  browser.fill_in("inputText", with: "#{row["산이름"]}")
  # browser.find(".textarea").send_keys("한라산")
  browser.click_on("Convert")
  
  doc = Nokogiri::HTML(browser.body)
  result = doc.css("#outputRMAddr").text
  
  # data_arr.push(result)
  output << [result, "#{row["높이(m)"]}"]

end

output.close