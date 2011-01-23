require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')
require 'gojira'


describe "connect" do
  before :all do
    @gojira = Gojira.new "http://sandbox.onjira.com"
  end

  it "should connect to the API" do
    @gojira.should_not be_nil
  end
  
  it "should login to the API" do
     @gojira.login("gojira", "gojira").should_not be_nil
  end

  describe "logged in actions" do
    before :all do
      @gojira.login("gojira", "gojira")
    end

    it "should list all projects" do
      @gojira.projects.should_not be_nil
    end

    it "should list all issues assigned to the current user" do
      @gojira.user_issues.should_not be_nil
      @gojira.user_issues.map(&:assignee).uniq.should == [@gojira.user]
    end

    it "should return a particular issue" do
      issues = @gojira.user_issues
      @gojira.issue(issues.first.key).should_not be_nil
    end
  end
end
