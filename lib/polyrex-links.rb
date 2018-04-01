#!/usr/bin/env ruby

# file: polyrex-links.rb

require 'polyrex'

class PolyrexLinks < Polyrex

  def initialize(x='links/link[name,url]', delimiter: ' # ', debug: false)
    super(x)
    self.delimiter = delimiter
    @debug = debug
  end

  def locate(raw_path)
    
    path = raw_path.sub(/^\//,'')
    a = path.split('/')
    a2 = []
    (a2 << a.clone; a.pop) while a.any?

    mask = "records/link[summary/name='%s']"
    
    begin 
      c = a2.shift; xpath = c.map{|x| mask % x}.join + '/summary/url/text()'
      r = self.element xpath 
    end until r or a2.empty?
    
    # return the found path along with any remaining string which 
    #   it didn't find, or it will return nil.
    
    puts "c: %s\npath: %s\nr: %s" % [c, path, r].map(&:inspect) if @debug
    
    r ? [r, path.sub(c.join('/'),'')] : nil
  end

end
