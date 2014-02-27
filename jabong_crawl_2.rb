require "rubygems"
require 'nokogiri'
require 'pp'
require 'open-uri'
require 'set'


def headers
	{"User-Agent" => "Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.10) Gecko/20100915 Ubuntu/10.04 (lucid) Firefox/3.6.10", "X-Requested-With" => "XMLHttpRequest"}
end

def process_page(page_id, csv_file)
	brand_list_women = ["United Colors of Benetton", "Chemistry", "Jealous 21", "Only", "Pepe Jeans", "Puma", "Reebok", "Vero Moda", "W", "Biba", "Aurelia", "Enamour"].to_set
	brand_list_men = ["United Colors of Benetton", "Adidas", "Puma", "Reebok", "Levi's", "Lee", "Wrangler", "Pepe Jeans", "U.S. Polo Assn.", "French Connection", "Van Heusen", "Van Heusen Sport", "Arrow", "Arrow New York", "Arrow Sports", "BEING HUMAN", "Jack & Jones", "Indian Terrain"].to_set
	flag = true
	url = "http://www.jabong.com/women/clothing/women-ethnic-wear/womens-sarees/?page=#{page_id}"
	puts url
	# csv_file = File.open("./women-t-shirts-jabong.csv", "a")
	page = Nokogiri::HTML(open(url, headers))
	puts "Loaded Page"
	# p page
	# puts puts puts puts puts puts puts puts
	list = page.css('a[unbxdattr=product]')
	# p list
	list.each do |item|
		flag = false
		data_arr = []
		begin
			brand = item.css('span[class=\'qa-brandName title mt10 c999\']').text
			next if brand == ""
			# next if(!brand_list_men.include?(brand))
			# product_url = item["href"]
			begin
				# sleep(1.0/10.0)
				# product_page = Nokogiri::HTML(open(product_url, headers))
			rescue Exception => e
				puts "Error loading Product Page: #{e}"
				retry
			end
			data_arr << brand
			# div = product_page.css('div[class=\'mid-row mb5 full-width\']')
			# if(div.css('span[class=c666]').text != "")
			# 	data_arr << "MP"
			# else
			# 	data_arr << "Jabong"
			# end
			data_arr << item.css('strong[class=fs16]').text.split('.')[1].to_i
			flag = false
		rescue Exception => e
			puts "Error in Scraping: #{e}"
		end
		p data_arr
		begin
			csv_file << data_arr
			csv_file << "\n"
		rescue Exception => e
			puts "Error Writing to File: #{e}"
			retry
		end
	end
	# csv_file.close
	return flag
end

def main 
	puts "Starting..."
	page_number = 0
	continue = false
	csvfile = File.open("./womens-sarees.csv", "a")
	while continue == false
		puts "page #{page_number}"		
		continue = process_page(page_number, csvfile)
		sleep(1.0)
		# break
		page_number = page_number + 1
		break if page_number == 200
	end
	csvfile.close
end

main

