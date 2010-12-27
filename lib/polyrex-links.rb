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
    xpath = path.split('/').map{|x| "records/link[summary/name='%s']" % x}\
      .join + '/summary/url/text()'
    @polyrex.element xpath
  end

  def to_xml(options={})
    @polyrex.to_xml(options)
  end
end
