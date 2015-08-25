require 'nokogiri'
require 'open-uri'

class Noko
  attr_reader :url

  def initialize(url)
    @url = URI.decode(url)
    @proxy_ips = [
      "173.234.232.73:3128",
      "170.130.62.25:3128",
      "50.2.44.103:3128",
      "173.234.249.159:3128",
      "173.234.249.180:3128",
      "173.234.232.10:3128",
      "173.234.249.138:3128",
      "173.234.249.53:3128",
      "50.2.44.197:3128",
      "170.130.62.125:3128"
    ]
    @user_agents = ["Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"]
  end

  def formatted
    {
      summary: summary,
      experience: experience,
      education: education,
      skills: skills,
      interests: interests,
      picture: picture
    }
  end

  def content
    content = Nokogiri::HTML(open(
      url, 
      'proxy' => @proxy_ips.sample,
      'User-Agent' => @user_agents.sample
    ))
    content.xpath('//script').remove
    content
  end

  def background
    @background ||= content.css('.background-content')
  end

  def text
    background.children.map(&:text).join(' ')
  end

  def summary
    background.css('#background-summary .description').text
  end

  def experience
    background.css('#background-experience').children[1..-1].map do |xp|
      {
        role: xp.css('h4').text,
        company: xp.css('h5').text,
        # previous position dates are only getting the "start_date -"
        date: xp.css('.experience-date-locale').children[0..1].text,
        locale: xp.css('.experience-date-locale .locality').text,
        description: xp.css('.description').text
      }
    end
  end

  def education
    background.css('#background-education').children[1..-1].map do |xp|
      {
        major: xp.css('h4').text,
        school: xp.css('h5').text,
        date: xp.css('.education-date').text
      }
    end
  end

  def skills
    #pop off the last skill in the array (check on smaller skill set)
    background.css('#background-skills li').map(&:text)
  end

  def interests
    background.css('#background-interests li').map(&:text)
  end

  def picture
    content.css('.profile-picture img')[0]['src']
  end
end

