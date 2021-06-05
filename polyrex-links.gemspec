Gem::Specification.new do |s|
  s.name = 'polyrex-links'
  s.version = '0.4.3'
  s.summary = 'A convenient gem for retrieving a link from a ' + 
      'hierarchical lookup table from a raw Polyrex document format'
  s.authors = ['James Robertson']
  s.files = Dir['lib/polyrex-links.rb']
  s.add_runtime_dependency('polyrex', '~> 1.3', '>=1.3.2') 
  s.signing_key = '../privatekeys/polyrex-links.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/polyrex-links'
  s.required_ruby_version = '>= 2.1.2'
end
