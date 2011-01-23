require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')
require 'gojira_api'

describe "gojira_api" do
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

		it "should return an issue's status" do
			issue_key = @gojira.user_issues.first.key
			status = @gojira.issue_status(issue_key)
			status.should_not be_nil
			["Open", "In Progress", "Reopened", "Resolved", "Closed", "QA", "Approved", "Develop"].should include status[:name]
		end

		it "should return a particular status" do
			statuses = @gojira.statuses
			@gojira.status(statuses.first[:id]).should == statuses.first
		end

		it "should return available statuses for an issue" do
			issue_key = @gojira.user_issues.first.key
			@gojira.valid_actions(issue_key).should_not be_empty
		end

		it "should set an issue's status" do
			issue_key = @gojira.user_issues.first.key
			action_key = @gojira.valid_actions(issue_key).first[:id]
			@gojira.set_action(issue_key, action_key).should_not be_nil
			action_key = @gojira.valid_actions(issue_key).first[:id]
			@gojira.set_action(issue_key, action_key).should_not be_nil
		end

		if ENV['test_comments']
			it "should add a comment to an issue" do
				issue_key = @gojira.user_issues.first.key
				@gojira.add_comment(issue_key, "my comment").body.should == "my comment"
			end
		end
	end
end
