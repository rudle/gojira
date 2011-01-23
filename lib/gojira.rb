require 'jira4r'
class Gojira
  attr_reader :user
  def initialize(url)
    @jira = Jira4R::JiraTool.new 2, url
    @jira.logger=Logger.new("/dev/null")
  end

  def login(user,pass)
    @user = user
    @jira.login user, pass
  end

  def projects
    @jira.getProjectsNoSchemes
  end

  def user_issues(limit = 10)
    @jira.getIssuesFromJqlSearch "assignee = currentUser()", limit
  end

  def issue(key)
    @jira.getIssue(key)
  end

  def method_missing(sym, *args, &block)
    @jira.send sym, *args, &block
  end

end
