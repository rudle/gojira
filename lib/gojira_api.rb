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

	def statuses
		@statuses ||= @jira.getStatuses.map do |s| 
			{
				:id => s.id, 
				:name => s.name,
				:desc => s.description,
			}
		end
	end

	def status id
		statuses.find{|s| s[:id] == id}
	end

	def issue_status(key)
		issue = issue(key)
		status(issue.status)
	end
	
	def valid_actions(key)
		@jira.getAvailableActions(key).map do |action|
			{
				:id => action.id,
				:name => action.name
			}
		end
	end

	def add_comment(key, body)
		comment = Jira4R::V2::RemoteComment.new
		comment.body = body
		@jira.addComment key, comment rescue return
		comment
	end

	def set_action(issue_key, action_key)
		action = valid_actions(issue_key).find {|action| action[:id] == action_key}
		return if not action
		@jira.progressWorkflowAction("FWL-696", action_key, []) rescue return
		action
	end

	def method_missing(sym, *args, &block)
		@jira.send sym, *args, &block
	end
end