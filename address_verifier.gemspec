Gem::Specification.new do |s|
  s.name        = 'address_verifier'
  s.version     = '0.0.1'
  s.date        = '2016-08-11'
  s.summary     = "Uses Yaddress API to verify addresses"
  s.description = "Returns an 'Address Verifier' object with the full address, any errors, and their error messages"
  s.authors     = ["Aashil Desai", "Gabe Heafitz"]
  s.email       = 'aashil@shopkeep.com'
  s.files       = ["Gemfile", "Gemfile.lock", "spec/spec_helper.rb", "spec/address_verifier_spec.rb","lib/address_verifier.rb"]
  s.homepage    =
    ''
  s.license       = 'MIT'
end