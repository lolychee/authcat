# frozen_string_literal: true

version = File.read(File.expand_path("../AUTHCAT_VERSION", __dir__)).strip

Gem::Specification.new do |spec|
  spec.name = "authcat-identity_provider"
  spec.version = version
  spec.authors       = ["lychee xing"]
  spec.email         = ["lolychee@gmail.com"]

  spec.summary       = "Write a short summary, because RubyGems requires one."
  spec.description   = "Write a longer description or delete this line."
  spec.homepage      = "https://github.com/lolychee/authcat"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/lolychee/authcat"
  spec.metadata["changelog_uri"] = "https://github.com/lolychee/authcat"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "zeitwerk", ">= 2.6.8"

  spec.add_dependency "authcat-credential", "~> #{version}"

  spec.add_dependency "omniauth", ">= 2.0"

  spec.metadata["rubygems_mfa_required"] = "true"
end
