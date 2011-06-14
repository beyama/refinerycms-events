Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinerycms-events'
  s.version           = '1.0'
  s.description       = 'Ruby on Rails Events engine for Refinery CMS'
  s.date              = '2011-06-10'
  s.summary           = 'Events engine for Refinery CMS'
  s.require_paths     = %w(lib)
  s.files             = Dir['lib/**/*', 'config/**/*', 'app/**/*']
  
  s.add_dependency    'has_scope',  '>= 0.5.0'
  s.add_dependency    'ri_cal', '>= 0.8.8'
  s.add_dependency    'geokit-rails3', "~> 0.1.3"
end
