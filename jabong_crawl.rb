require "rubygems"
require "Nokogiri"
require 'open-uri'
require 'csv'

def user_agent
	{"User-Agent" => "Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.10) Gecko/20100915 Ubuntu/10.04 (lucid) Firefox/3.6.10"}
end

vertical = "mens-shirts/men-casual-shirts"
base_url = "http://www.jabong.com/men/clothing/"
url = base_url+vertical+"?price="
price_range = ["0-15000"] # "0-700", "800-1199", "1200-1699", "1700-7199"


price_range.each do |range|
	get_url = url+range
	puts "Processing url........#{get_url}"
	csv_file = File.open("./mens-casual-shirts.csv", "a")
	csv_file << "\n\n\n\n\n"
	csv_file << range
	csv_file << "\n\n"
	begin
		puts "Fetching url....."
		page = Nokogiri::HTML(open(get_url, user_agent))
	rescue Exception => e
		puts "Error: #{e}"
		sleep(1.0/5.0)
		retry
	end
	brands = page.css('div#facet_brand a')
	brands.each do |link|
		data = link.text.match(/(.+)\((.+)\)/)
		arr=[]
		begin
			arr << data[1]
			arr << data[2].to_i
		rescue Exception => e
			puts "Error in scraping data: #{e}"
		end
		begin
			csv_file << arr
			csv_file << "\n"
		rescue Exception => e
			puts "Error in writing to csv #{e}"
		end
	end
	csv_file.close
	sleep(1.0/10.0)
end


