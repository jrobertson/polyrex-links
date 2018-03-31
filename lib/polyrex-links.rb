#!/usr/bin/env ruby

# file: polyrex-links.rb

require 'polyrex'

class PolyrexLinks < Polyrex

  def initialize(x='links/link[name,url]')
    super(x)
    self.delimiter = ' # '
  end

  def locate(path)
    
    a = path.sub(/^\//,'').split('/')
    a2 = []
    (a2 << a.clone; a.pop) while a.any?

    mask = "records/link[summary/name='%s']"
    
    begin 
      c = a2.shift; xpath = c.map{|x| mask % x}.join + '/summary/url/text()'
      r = self.element xpath 
    end until r or a2.empty?
    
    # return the found path along with any remaining string which 
    #   it didn't find, or it will return nil.
    r ? [r + path.sub(c.join('/'),''), path.sub(c.join('/'),'')] : nil
  end

end
