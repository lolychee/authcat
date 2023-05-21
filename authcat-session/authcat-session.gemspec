# frozen_string_literal: true

version = File.read(File.expand_path("../AUTHCAT_VERSION", __dir__)).strip

Gem::Specification.new do |spec|
  spec.name    = "authcat-session"
  spec.version = version
  spec.authors = ["lychee xing"]
  spec.email   = ["lolychee@gmail.com"]

  spec.summary     = "Write a short summary, because RubyGems requires one."
  spec.description = "Write a longer description or delete this line."
  spec.homepage    = "https://github.com/lolychee/authcat"
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/lolychee/authcat"
  spec.metadata["changelog_uri"] = "https://github.com/lolychee/authcat"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "zeitwerk", ">= 2.6.8"

  spec.add_dependency "authcat-credential", version
  spec.add_dependency "authcat-identifier", version
  spec.add_dependency "authcat-password", version

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
