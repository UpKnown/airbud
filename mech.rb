class LinkedinMech
  attr_reader :page, :agent

  def initialize(name)
    @agent = Mechanize.new
    @page  = agent.get('https://www.linkedin.com')
  end

  def search(first, last)
    search_form = page.form('searchForm')
    search_form.first = first
    search_form.last  = last
    agent.submit(search_form, search_form.buttons.first)
  end
end
