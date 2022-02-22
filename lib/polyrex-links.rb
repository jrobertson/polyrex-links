#!/usr/bin/env ruby

# file: polyrex-links.rb

require 'polyrex'

class PolyrexLinks < Polyrex

  def initialize(rawx='links/link[title,url]', delimiter: ' # ', debug: false)

    x, _ = RXFReader.read(rawx)
    obj = x.lstrip.sub(/<\?polyrex-links\?>/,
                  '<?polyrex schema="links/link[title,url]" delimiter=" # "?>')
    puts 'obj: ' + x.inspect if debug

    super(obj)
    @delimiter = self.delimiter = delimiter
    @debug = debug

  end

  def find(s)

    found = find_by_link_title s

    if found then

      path = backtrack_path found
      [link(path.join('/')), path.join('/')]

    end

  end

  # returns a listing of all links sorted by title in alphabetical order
  #
  def index()

    a = []
    each_recursive {|link|  a << [link.title, link.url, backtrack_path(link)] }
    a.sort_by {|title, _, _| title.downcase}

  end

  def migrate(raws)

    s, _ = RXFReader.read(raws)
    pl = PolyrexLinks.new("<?polyrex-links?>\n\n" +
                          s.sub(/<\?[^\?]+\?>/,'').lstrip)

    pl.each_recursive do |x|
      link, linkpath = find(x.title)
      x.url = link.url if link and link.url
    end

    pl

  end

  # Returns the Polyrex element for the given path
  #
  def link(s)

    self.rxpath(s.split('/').map {|x| "link[title='%s']" % x}.join('/')).first

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

    mask = "records/link[summary/title='%s']"

    begin
      c = a2.shift; xpath = c.map{|x| mask % x}.join + '/summary/url/text()'
      r = self.element xpath
    end until r or a2.empty?

    # return the found path along with any remaining string which
    #   it didn't find, or it will return nil.

    puts "c: %s\npath: %s\nr: %s" % [c, path, r].map(&:inspect) if @debug

    r ? [r, path.sub(c.join('/'),'')] : nil
  end

  def save(filepath)

    super(filepath)
    export(filepath.sub(/\.xml$/,'.txt'))

  end

  def search(keyword)
    index().select {|x| x.first =~ /\b#{keyword}/}
  end


  # Return a flat Hash object containing all the links. The link path is
  # used as the key and the value is the url
  #
  def to_h()

    h = {}

    each_link {|key, value| h[key] = value }
    h

  end

  def to_s()
    "<?polyrex-links?>\n\n" + super(header: false)
  end

  private

  def backtrack_path(e, a5=[])

    backtrack_path(e.parent, a5)  if e.parent?
    a5 << e.title

    return a5
  end


  def each_link()

    a = []

    self.each_recursive() do |record, _, i|

        a.slice!(i..-1)
        a[i] = record
        yield(a.map(&:title).join('/'), record.url) if block_given?

    end

  end

end
