#Introducing the Polyrex links gem 0.1.2

The polyrex-links gem was intended to run as a back-end web service to handle clean URL requests and return the associated longer URL. I've been experimenting with QR codes, and I've reached the conclusion it's better to change the associated URL behind a clean URL, than it is to regenerate and print out QR codes each time.


    require 'polyrex-links'

    lines =<<LINES
    food http://kitchen.com/food
      fruit http://kitchen.com/fruit
        apples http://kitchen.com/fruit?q=apples
        pears http://kitchen.com/fruit?q=pears
    spoons http://kitchen.com/spoons
    LINES

    links = PolyrexLinks.new
    links.parse lines
    puts links.to_xml pretty: true

    links.locate "food/fruit/"

However say for example it refers to a physical directory which is:
<pre>/home/james/dws2/images</pre>

the clean URL stored in polyrex-links may look like this:
<pre>/images</pre>

and the actual URL requested may be:
<pre>/images/sunshine.jpg</pre>

and the target URL is <pre>/do/file/read?name=images</pre>

after locating the polyrex-link the target URL would be:
<pre>/do/file/read?name=images/sunshine.jpg</pre>
