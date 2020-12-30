# frozen_string_literal: true

version = File.read(File.expand_path('../AUTHCAT_VERSION', __dir__)).strip

Gem::Specification.new do |spec|
  spec.name          = 'authcat-password'
  spec.version       = version
  spec.authors       = ['lychee xing']
  spec.email         = ['lolychee@gmail.com']

  spec.summary       = 'Write a short summary, because RubyGems requires one.'
  spec.description   = 'Write a longer description or delete this line.'
  spec.homepage      = 'https://github.com/lolychee/authcat'
  spec.license       = 'BSD'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  # spec.metadata["allowed_push_host"] = "Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/lolychee/authcat'
  spec.metadata['changelog_uri'] = 'https://github.com/lolychee/authcat'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir['README.md', 'BSD-LICENSE', 'lib/**/*']

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'dry-container', '>= 0.7.2'
  spec.add_dependency 'zeitwerk', '>= 2.4.2'
end
