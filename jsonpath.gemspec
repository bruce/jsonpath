# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jsonpath}
  s.version = "0.8.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bruce Williams"]
  s.date = %q{2009-07-17}
  s.email = %q{bruce@codefluency.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "jsonpath.gemspec",
     "lib/jsonpath.rb",
     "lib/jsonpath/nodes.rb",
     "lib/jsonpath/parser.rb",
     "lib/jsonpath/parser.treetop",
     "test/parser_test.rb",
     "test/reference_test.rb",
     "test/test_helper.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/bruce/jsonpath}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{JSONPath support for Ruby}
  s.test_files = [
    "test/parser_test.rb",
     "test/reference_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<treetop>, [">= 0"])
    else
      s.add_dependency(%q<treetop>, [">= 0"])
    end
  else
    s.add_dependency(%q<treetop>, [">= 0"])
  end
end
