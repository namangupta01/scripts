require 'mechanize'
require 'csv'
URL = "http://www.example.com/"
URL_PATTERN_MATCH1 = ""http://www.example.com/"
URL_PATTERN_MATCH2 = ""http://www.example.com/"
a = []
agent = Mechanize.new
page = agent.get(URL)

csv1 = CSV.open("file.csv", "wb")
csv2 = CSV.open("file.csv", "wb")

page.links.each do |link|
	if !a.include?(link.href)
		if link.href.include?(URL_PATTERN_MATCH1)
			a << link.href
		end
	end
end
global_array = []

a.each do |i|
	global_array << i
end
book1_row_number = 1
book2_row_number = 1
while !a.empty? do
	b = []
	a.each do |i|
		begin
			page = agent.get(i)
			page.links.each do |link|
				if !global_array.include?(link.href)
					if link.href != nil && link.href.include?(URL_PATTERN_MATCH1)
						b << link.href
						global_array << link.href
						puts link.href
						csv1 << [link.href]
						if link.href.include?(URL_PATTERN_MATCH2)
							csv2 << [link.href]
						end
					end
				end
			end
		rescue Exception => e
			puts e
			puts "====================================="
			puts i
			puts "====================================="
		end 
	end
	a = b
end
