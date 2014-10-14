require 'pry-byebug'
require 'marky_markov'
require 'open-uri'
require 'json'

markov = MarkyMarkov::TemporaryDictionary.new

# Wikipedia pages to scrape and train the markov chain
terms = ['Database', 'Breast', 'Web application', 'Cloud computing', 'Waffle', 'Data']

# Word replacements
@replacements = {'cloud' => 'butt',
                'Cloud' => 'Butt'}

def replace_content content
  @replacements.each do |key, value|
    content.gsub!(key, value)
  end
end

def strip_html content
  content.gsub!(/<\/?[^>]*>/, '')
end

terms.each do |term|
  url = "http://en.wikipedia.org/w/api.php?format=json&action=query&titles=#{term.gsub(' ', '%20')}&prop=extracts"

  parsed_response = JSON.load(open(url))

  extracted_content = parsed_response["query"]["pages"].first[1]["extract"]

  replace_content(extracted_content)
  strip_html(extracted_content)
  markov.parse_string extracted_content
end

binding.pry

markov.generate_15_sentences