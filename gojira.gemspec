Gem::Specification.new do |s|
  s.name = "gojira"
  s.version = "0.1.1"
  s.date = Time.now
  s.authors = ["Sean Sorrell"]
  s.email = "seansorrell@gmail.com"
  s.summary = "a git-like command interface to Atlassian Jira"
  s.description = "gojira provides the ability to view tickets and move them through a Jira workflow"
  s.homepage = "http://github.com/rudle/gojira"
  s.files = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md)
  s.require_path = 'lib'
	s.bindir = "bin"
  s.executables = ["gojira","gj"]

	s.add_dependency "wireframe-jira4r"
end

