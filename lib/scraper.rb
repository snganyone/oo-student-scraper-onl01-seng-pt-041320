require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
        
    doc = Nokogiri::HTML(open(index_url))

    doc.css("div.student-card").each do |card|
      name = card.css(".student-name").text
      location = card.css(".student-location").text
      profile = card.css("a").attribute("href").value
      info_hash = {:name => name,
                  :location => location,
                  :profile_url => profile
                  }
      students << info_hash
    end

    students

  end

  def self.scrape_profile_page(profile_url)
    info = {}

    doc = Nokogiri::HTML(open(profile_url))

    pages = doc.css("div.social-icon-container a").collect{|icon| icon.attribute('href').value}

    pages.each do |link|
      if link.include?('twitter')
        info[:twitter] = link
      elsif link.include?('linkedin')
        info[:linkedin] = link
      elsif link.include?('github')
        info[:github] = link
      else 
        info[:blog] = link
      end
    end

    info[:profile_quote] = doc.css(".profile-quote").text
    info[:bio] = doc.css("div.description-holder p").text
    info

  end

end

