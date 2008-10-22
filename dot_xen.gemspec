# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dot_xen}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Corey Donohoe"]
  s.autorequire = %q{dot_xen}
  s.date = %q{2008-10-14}
  s.description = %q{A gem that provides reading and writing utils for xen config files.  It's also a really simple use of treetop}
  s.email = %q{atmos@atmos.org}
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README", "Rakefile", "TODO", "lib/dot_xen.rb", "lib/xen", "lib/xen/ast.rb", "lib/xen/grammar.treetop", "lib/xen/grammar_node_classes.rb", "lib/xen/pretty_print_visitor.rb", "lib/xen/visitor.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://atmos.org}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{A gem that provides reading and writing utils for xen config files.  It's also a really simple use of treetop}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<treetop>, [">= 0"])
    else
      s.add_dependency(%q<treetop>, [">= 0"])
    end
  else
    s.add_dependency(%q<treetop>, [">= 0"])
  end
end
