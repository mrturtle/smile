# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{smile}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["cajun"]
  s.date = %q{2009-07-11}
  s.email = %q{zac@kleinpeter.org}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".yardoc",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION.yml",
     "lib/smile.rb",
     "lib/smile/album.rb",
     "lib/smile/base.rb",
     "lib/smile/param_converter.rb",
     "lib/smile/photo.rb",
     "lib/smile/smug.rb",
     "smile.gemspec",
     "test/smile_test.rb",
     "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/cajun/smile}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{cajun-gems}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Simple API for talking to SmugMug}
  s.test_files = [
    "test/smile_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rest-client>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
    else
      s.add_dependency(%q<rest-client>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
    end
  else
    s.add_dependency(%q<rest-client>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
  end
end
