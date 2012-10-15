class StructureAnalysis
  require 'strscan'

  attr_reader :input, :sentence

  def initialize input
    @input = input
    @sentence = sentence
    @end_of_input = end_of_input
  end

  def sentence
    input[-1].match(/[\.\?!]/) ? input.chop : input
  end

  def end_of_input
    match = input[-1].match(/[\.\?!]/)
    unless match.nil?
      match[0]
    end    
  end

  def structure
    structured = []
    if m = sentence.match(/,/)
      structured << m.pre_match.strip
      structured << m.post_match.strip
      structured.map { |x| x.split(/\s/) }
    else structured << sentence.split(/\s/) 
    end
  end
end


