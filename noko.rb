class Noko
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def all
    content = Nokogiri::HTML.parse(open(url))
    content.xpath('//script').remove
    content.css('.background-content').children.map(&:text).join(' ')
  end
end
