require 'watir'
require 'highline/import'

browser = Watir::Browser.new :chrome
browser.goto 'https://web.whatsapp.com/'
# browser.driver.manage().window().maximize
# screen_width = browser.execute_script("return screen.width;")
# puts "1"
# screen_height = browser.execute_script("return screen.height;")
# puts "2"
# browser.driver.manage.window.resize_to(screen_width,screen_height)
# puts "3"
# browser.driver.manage.window.move_to(0,0)
# puts "4"

sleep 10

name = ask("Enter name: ")
browser.text_field(:class=>"input input-search").set name
browser.send_keys :enter
browser.span(:title => "#{name}").click
sleep 2
message = "Sorry......... Just Checking my script"
num = 1
50.times do
	browser.send_keys ["#{num}"]
	browser.send_keys ["."]
		browser.send_keys ["#{message}"]
	puts "#{num} time(s) done"
	browser.send_keys :enter
	num = num + 1
end
s = gets