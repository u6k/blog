require 'nokogiri'

module ReadingTimeFilter

  def count_words(html)
    words(html).length
  end

  def count_characters(html)
    words(html).map { |word| word.length }.inject(:+)
  end

  def reading_time(html)
    (count_characters(html) / 500.0).ceil
  end

  private

  def text_nodes(root)
    ignored_tags = %w[area audio canvas code embed footer form img map math nav object pre script svg table track video]
    texts = []
    root.children.each do |node|
      if node.text?
        texts << node.text
      elsif not ignored_tags.include? node.name
        texts.concat text_nodes node
      end
    end
    texts
  end

  def words(html)
    fragment = Nokogiri::HTML.fragment html
    text_nodes(fragment).map { |text| text.scan(/[\p{L}\p{M}p{M}'‘’]+/) }.flatten
  end

end

Liquid::Template.register_filter(ReadingTimeFilter)
