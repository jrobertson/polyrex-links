#!/usr/bin/env ruby

# file: polyrex-links.rb

require 'polyrex'

class PolyrexLinks < Polyrex

  def initialize(x='links/link[name,url]')
    super(x)
  end

  def locate(path)
    
    a = path.split('/')
    a2 = []
    (a2 << a.clone; a.pop) while a.any?

    mask = "records/link[summary/name='%s']"
    
    begin 
      c = a2.shift; xpath = c.map{|x| mask % x}.join + '/summary/url/text()'
      r = self.element xpath 
    end until r or a2.empty?
    
    r ? r + path.sub(c.join('/'),'') : nil
  end

end
