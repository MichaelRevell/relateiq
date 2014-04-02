Gem::Specification.new do |s|
  s.name        = 'relateiq'
  s.version     = '0.0.1'
  s.date        = '2014-04-01'
  s.summary     = "RelateIQ Ruby Client"
  s.description = "A lightweight ruby wrapper for the RelateIQ API"
  s.authors     = ["Michael Revell"]
  s.email       = 'michael@crowditlt.com'
  s.homepage    = 'https://www.crowdtilt.com/learn/developers'
  s.license = 'MIT'

  s.add_development_dependency 'bundler', '~> 1.0'

  s.add_runtime_dependency 'faraday', ['~> 0.8', '< 0.10']
  s.add_runtime_dependency 'faraday_middleware', '~> 0.9.0'
  s.add_runtime_dependency 'activesupport'
  s.add_runtime_dependency 'json'

  s.files = `git ls-files`.split("\n")
  s.require_paths = ['lib']

end
