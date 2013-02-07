Gem::Specification.new do |s|
  s.name = 'polyrex-links'
  s.version = '0.1.6'
  s.summary = 'polyrex-links'
  s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb']
  s.add_dependency('polyrex') 
  s.signing_key = '../privatekeys/polyrex-links.pem'
  s.cert_chain  = ['gem-public_cert.pem']
end
