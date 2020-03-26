Gem::Specification.new do |s|
  s.name     = 'devise-specs'
  s.version  = '0.0.5'
  s.authors  = ["Gaspard d'Hautefeuille"]
  s.email    = 'github@dhautefeuille.eu'
  s.summary  = 'Generates the Devise acceptance tests.'
  s.homepage = 'https://github.com/HLFH/devise-specs'
  s.license  = 'MIT'
  s.files    = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|features|fixtures)/}) }
  
  s.required_ruby_version = '>= 2.7.0'

  s.add_runtime_dependency 'devise', '~> 4.7', '>= 4.7.1'

  s.add_development_dependency 'rake', '~> 13.0', '>= 13.0.1'
  s.add_development_dependency 'aruba', '~> 1.0'
end
