# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name     = 'devise_specs'
  s.version  = '0.0.7'
  s.authors  = ["Gaspard d'Hautefeuille"]
  s.email    = 'ruby@dhautefeuille.eu'
  s.summary  = 'Upgrade that generates the Devise acceptance tests for Rails 6+'
  s.homepage = 'https://github.com/HLFH/devise_specs'
  s.license  = 'MIT'
  s.files    = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|features|fixtures)/}) }

  s.required_ruby_version = '>= 2.7'

  s.add_runtime_dependency 'devise', '~> 4.7', '>= 4.7.1'

  s.add_development_dependency 'aruba', '~> 1.0'
  s.add_development_dependency 'rake', '~> 13.0', '>= 13.0.1'
  s.add_development_dependency 'simplecov', '~> 0.17.1'
end
