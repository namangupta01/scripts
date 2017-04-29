require 'watir'
require 'highline/import'
require 'open-uri'

browser = Watir::Browser.new :chrome
browser.goto "facebook.com"
sleep 2
email = ask("Enter email: ")
browser.text_field(:id => "email").set email
password = ask("Enter password: "){ |q| q.echo = false }
browser.text_field(:id => "pass").set password
browser.form(:id => "login_form").submit
sleep 10

name = ask("Enter name of the hottie: ")
browser.text_field(:name => "q").set name
browser.form(:action => "/search/web/direct_search.php").submit
sleep 5

browser.link(:class => " _2yez").click
sleep 5
browser.link(:class => "profilePicThumb").click
img = browser.image(:class => "spotlight")

File.open("Desktop/test.jpg", 'wb') |f| do
	f << open(img.src).read
end

browser.image(:class => "spotlight").click