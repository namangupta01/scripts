require 'watir'
require 'highline/import'

browser = Watir::Browser.new :chrome
browser.goto("https://www.twitter.com")
sleep 10
browser.a(:class=>"Button StreamsLogin js-login").click
email=ask("Enter Email ")
browser.text_field(:class=>"text-input email-input js-signin-email").set email
password=ask("Enter Password ")
browser.div(:class=>"LoginForm-input LoginForm-password").text_field.set password
browser.div(:class=>"LoginForm-rememberForgot").checkbox.set "checked"
browser.input(:class=>"submit btn primary-btn js-submit").click
sleep 10
browser.div(:id=>"tweet-box-home-timeline").div.click
tweet=ask("Enter tweet content")
browser.send_keys(tweet)
browser.button(:class=>"btn primary-btn tweet-action tweet-btn js-tweet-btn").click
sleep 10



