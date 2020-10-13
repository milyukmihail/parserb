
require 'nokogiri'
require 'curb'
require 'csv'

url = ARGV.first

file = ARGV.last

http = Curl.get(url) do |http|
http.headers['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.106 Safari/537.36'
end
puts "Скачиваю страницу"

puts "Открываю файл для записи"
puts "Записываю данные в файл"
CSV.open(file, "w") do |csv_line|
  csv_line << ['Название', 'Цена', 'Изображение']

  product_page_html = Nokogiri::HTML(http.body_str)

    product_page_html.xpath('.//a[@class="product-name"]/@href').each do |url|

    page_http = Curl.get(url)
    product_page_html = Nokogiri::HTML(page_http.body_str)

    pr_name = product_page_html.xpath('//h1[@class="product_main_name"]').text
    pr_img = product_page_html.xpath('//img[@id="bigpic"]/@src')
    attr_pr_list = product_page_html.xpath('//div[@id="attributes"]')
    attr_pr_list.each do |attr|
      pr_pre_pack = attr.xpath('//span[@class="radio_label"]').text
      pr_price = attr.xpath('//span[@class="price_comb"]').text

      full_info = ["#{pr_name} - #{pr_pre_pack}", pr_price, pr_img]
      csv_line << full_info
    end
  end
end