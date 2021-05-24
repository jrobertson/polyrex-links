#!/usr/bin/env ruby

# file: polyrex-links.rb

require 'polyrex'

class PolyrexLinks < Polyrex

  def initialize(x='links/link[name,url]', delimiter: ' # ', debug: false)
    super(x)
    @delimiter = self.delimiter = delimiter
    @debug = debug
  end
  
  def find(s)
    
    found = find_by_link_name s
    
    if found then
      
      path = backtrack_path found 
      [locate(path.join('/')), path.join('/')]
      
    end
    
  end
  
  # Returns the Polyrex element for the given path
  #
  def link(s)
    
    self.rxpath(s.split('/').map {|x| "link[name='%s']" % x}.join('/')).first
    
  end
  
  # Returns the url and remaining arguments for the given path
  #
  def locate(raw_path)
   
    return nil if raw_path.nil? or raw_path.strip.empty?
    path = raw_path.sub(/^\//,'')
    a = path.split('/')
    a2 = []
    (a2 << a.clone; a.pop) while a.any?
    return nil if a2.empty?
    
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
  
  
  # Return a flat Hash object containing all the links. The link path is 
  # used as the key and the value is the url
  #
  def to_h()
    
    h = {}
    
    each_link {|key, value| h[key] = value }
    h
    
  end
  
  private
  
  def backtrack_path(e, a5=[])

    backtrack_path(e.parent, a5)  if e.parent?
    a5 << e.name

    return a5
  end
  

  def each_link()

    a = []
    
    self.each_recursive() do |record, _, i|       
      
        a.slice!(i..-1)
        a[i] = record
        yield(a.map(&:name).join('/'), record.url) if block_given?
        
    end
             
  end  

end
