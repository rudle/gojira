require 'jira4r'
class GojiraAPI
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

	def user_issues(limit = 100)
		@jira.getIssuesFromJqlSearch "assignee = currentUser()", limit
	end

	def issue(key)
		@jira.getIssue(key)
	end

	def priorities
		@priorities ||= @jira.getPriorities.map do |p|
			{
				:id => p.id,
				:name => p.name,
				:desc => p.description
			}
		end
	end

	def priority(id)
		priorities.find { |p| p[:id] == id }
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

	def status(id)
		statuses.find{|s| s[:id] == id}
	end

	def issue_status(key)
		issue = issue(key)
		status(issue.status)
	end

	def issue_priority(key)
		issue = issue(key)
		priority(issue.priority)
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
		@jira.progressWorkflowAction(issue_key, action_key, []) rescue return
		action
	end

	def method_missing(sym, *args, &block)
		@jira.send sym, *args, &block
	end
end
