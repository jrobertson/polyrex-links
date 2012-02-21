#!/usr/bin/ruby

# file: polyrex-links.rb

require 'polyrex'

class PolyrexLinks

  def initialize(x='links/link[name,url]')
    @polyrex = Polyrex.new(x)
  end

  def parse(s)
    @polyrex.parse s
  end

  def locate(path)
    
    a = path.split('/')
    a2 = []
    (a2 << a.clone; a.pop) while a.any?

    mask = "records/link[summary/name='%s']"
    
    begin 
      c = a2.shift; xpath = c.map{|x| mask % x}.join + '/summary/url/text()'
      r = @polyrex.element xpath 
    end until r or a2.empty?
    
    r ? r + path.sub(c.join('/'),'') : nil
  end

  def to_xml(options={})
    @polyrex.to_xml(options)
  end
end
