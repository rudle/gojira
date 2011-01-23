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
		statuses.select do |s| 
			@jira.getAvailableActions(key).map(&:id).include? s[:id]
		end
	end

	def add_comment(key, body)
		comment = Jira4R::V2::RemoteComment.new
		comment.body = body
		@jira.addComment key, comment rescue return nil
		comment
	end

	def set_status(issue_key, status_key)
		@jira.progressWorkflowAction("FWL-696", 1, [])
	end

	def method_missing(sym, *args, &block)
		@jira.send sym, *args, &block
	end
end
