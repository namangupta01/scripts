require 'watir'
require 'highline/import'

browser = Watir::Browser.new :chrome
browser.goto 'https://www.facebook.com/'
# browser.driver.manage().window().maximize
# screen_width = browser.execute_script("return screen.width;")
# puts "1"
# screen_height = browser.execute_script("return screen.height;")
# puts "2"
# browser.driver.manage.window.resize_to(screen_width,screen_height)
# puts "3"
# browser.driver.manage.window.move_to(0,0)
# puts "4"

email = ask("Enter email: ")
browser.text_field(:id => 'email').set email
password = ask("Enter password: ") { |q| q.echo = false }
browser.text_field(:id => 'pass').set password
browser.form(:id => 'login_form').submit
sleep 10

name = ask("Enter name: ")

browser.text_field(:placeholder => 'Search').set "#{name}"
sleep 2
browser.send_keys :enter
sleep 2
browser.div(:class => "_1mf _1mj").click
sleep 1
 message = "Sorry......... Just Checking my script"
num = 1
100.times do
	browser.send_keys ["#{num}"]
	browser.send_keys ["."]
	for i in 0..message.size
		browser.send_keys ["#{message[i]}"]
	end
	puts "#{num} time(s) done"
	browser.send_keys :enter
	num = num + 1
end
s = gets