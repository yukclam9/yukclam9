# -*- coding: utf-8 -*-
from scrapy.contrib.spiders import CrawlSpider , Rule
from scrapy.contrib.linkextractors import LinkExtractor
from kmss.items import KmssItem


class FirstSpider(CrawlSpider):
    name = "first"
    ## you do not find it to go to facebook links 
    allowed_domains = ["www.reddit.com"]
    start_urls = [
        'http://www.reddit.com/r/pics/',
    ]
    
#    #follow : whenever you go to a new page, you want it to stop and study the page
    rules = [Rule(LinkExtractor(allow = ['/r/pics/\?count=\d*&after=\w*']), callback = "parse_item", 
                  follow = True)] 

## if you have another 'format' of url to follow, you could add another rule with rules and callback
## to another function
## every function that is a call back object requires a response at argument
    def parse_item(self, response):
        ##at here you could make a request , dynamically
        ##Request(link, callback=self.another_function) and 
        ## use view at command line to check your page without js
        ##css / xpath to pick information from html
        selector_list = response.css('div.thing')
        
        for selector in selector_list:
            ## create an instance
            item = KmssItem()
            item['title'] =  selector.xpath('div/p/a/text()').extract()
            yield item
