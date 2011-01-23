require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'spec_helper')
require 'bin/gojira'

describe "gojira" do
	before :all do
		@gojira = Gojira.new "http://sandbox.onjira.com", "gojira", "gojira"
	end
	describe "load up" do
		it "should connect to the API" do
			@gojira.should_not be_nil
			@gojira.gojira.should_not be_nil
		end
	end

	describe "output functions" do
		before :all do
			#@gojira.stub!(:print)
		end

		it "should print the projects" do
			@gojira.should_receive(:print)
			@gojira.show_projects
		end

		describe "issue commands" do
			it "should print the users issues" do
				@gojira.should_receive(:print)
				@gojira.show_issues
			end

			it "should print issue info given an issue's internal ID" do
				@gojira.should_receive(:print)
				@gojira.show_issues(0).should 
			end
		end

		describe "update_status" do
			it "should print out possible statuses when called with one argument" do
				@gojira.should_receive(:print).once
				@gojira.update_status @gojira.gojira.user_issues.first.key
			end

			it "should set the action of the specified ticket to the specified action" do
				issue_key = @gojira.gojira.user_issues.first.key
				@gojira.update_status issue_key, 0
			end

		end
	end

	describe "input options" do

		it "should show issues when it receives an issues command" do
			@gojira.should_receive(:show_issues).once
			@gojira.run ["issues"]
		end

		it "should show issues and parse the id argument" do
			@gojira.should_receive(:show_issues).once.with(0)
			@gojira.run ["issues",0]
		end

		it "should show projects when it receives a project command" do
			@gojira.should_receive(:show_projects).once
			@gojira.run ["projects"]
		end
	end

end
