# frozen_string_literal: true

require_relative 'lib/safe_polymorphic/version'

Gem::Specification.new do |spec|
  spec.name = 'safe_polymorphic'
  spec.version = SafePolymorphic::VERSION
  spec.licenses = ['MIT']
  spec.authors = ['Nicolas Erlichman']
  spec.email = ['nicolas@gogrow.dev']

  spec.summary = 'Safely use polymorphic associations by validating which classes are allowed to be related to.'
  spec.description = 'ActiveRecord extension which allows us to safely use polymorphic associations, by validating' \
   'which classes are allowed to be related to, while also adding scopes and helper methods.'
  spec.homepage = 'https://github.com/gogrow-dev/safe_polymorphic'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/master/CHANGELOG.md"
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '>= 5.2', '< 7.1'
end
