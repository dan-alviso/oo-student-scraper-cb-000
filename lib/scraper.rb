require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = Array.new
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    doc.css(".student-card").each do |student_card|
      profile = {:name => student_card.css(".student-name").text,
                 :location => student_card.css(".student-location").text,
                 :profile_url => student_card.css("a").attribute("href").text
      }
      students << profile
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML (html)
    arr = []
    social = []
    #Get all the links within social-icon-container class and list them as an array
    doc.css(".vitals-container").css(".social-icon-container a").each do |website|
      arr << website.attribute("href").text
    end
    hash = Hash.new
    #Go through array and add applicable social media links
    arr.each do |site|
      if site.include?("twitter")
        hash[:twitter] = site
      elsif site.include?("linkedin")
        hash[:linkedin] = site
      elsif site.include?("github")
        hash[:github] = site
      else
        hash[:blog] = site
      end
    end

    #Get profile quote
    hash[:profile_quote] = doc.css(".vitals-container").css(".vitals-text-container div.profile-quote").text
    #Get profile bio
    hash[:bio] = doc.css(".details-container .description-holder p").text
    hash
  end
end
