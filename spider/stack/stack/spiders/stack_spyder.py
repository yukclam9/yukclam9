# -*- coding: utf-8 -*-
"""
Created on Sun Jul 19 16:06:42 2015

@author: casey
"""
from scrapy.crawler import Crawler
from scrapy import Spider
from scrapy.selector import Selector
from stack.items import StackItem

class stack_spider(Spider):
    name ="stack"
    allowed_domains = ['stackoverflow.com']
    staturls= ["http://stackoverflow.com/questions?pagesize=50&sort=newest",
              ]
              
    def parse(self,response):
        # grab all h3 element thar are the children of div and having the class= summary
        questions= Selector(response).xpath('//div[@class="summary"]/h3')    
        
        for question in questions:
            item= StackItem()
            ## under h3, there is a class called question-hyperlink 
            ## and text() should be some standard syntax
            item['title'] = question.xpath('a[@class="question-hyperlink"]/text()').extract()[0]
            item['url']   = question.xpath('a[@class="question-hyperlink"]/@href').extract()[0]
            yield item
            
#https://realpython.com/blog/python/web-scraping-with-scrapy-and-mongodb/