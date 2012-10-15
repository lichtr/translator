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
    sc = StringScanner.new(sentence)
    pos = []

    while sc.scan_until(/,/)
        pos << sc.pos
    end

    case pos.size
    when 0
      structured << sentence 
    when 1
      structured << sentence[0...pos[0]]
      structured << sentence[pos[0]..-1]
    when 2
      structured << sentence[0...pos[0]].concat(sentence[pos[1]..-1])
      structured << sentence[pos[0]...pos[1]]
    end

    structured.map { |x| x.strip }
    structured.map do |x|
      if x.include?(",")
        x.delete(",")
      end
    end

    structured.map { |x| x.split(/\s/) }
  end
end


