require 'lib/gojira_api'

class Gojira
	attr_reader :gojira

	def initialize(url, user, pass)
		@gojira = GojiraAPI.new url
		@gojira.login user,pass
	end

	def run(args)
		parse_args(args)
	end

	def show_projects
		output = @gojira.projects.map do |project|
			"#{project.key} - #{project.url}"
		end
		print output
	end
	
	def show_issues issue_id=nil
		output = @gojira.user_issues.enum_with_index.map do |issue,id|
			"#{id} \t #{format_issue issue,issue_id}"
		end
		output = output[issue_id] if issue_id
		print output
	end

	def update_status(issue,new_action=nil)
	issue = externalize_issue(issue)
		valid_actions = @gojira.valid_actions(issue)
		output = valid_actions.enum_with_index.map do |action,id|
			"#{id} - #{format_action action}"
		end
		if new_action
			if (resp = @gojira.set_action issue, valid_actions[new_action.to_i][:id])
				output = "set to #{resp[:name]}"
			else
				output = "failed to perform action - maybe it is invalid?"
			end
		end
		print output
	end

	protected
	def print out
		puts out
		return out
	end

	def format_issue(issue, verbose=false)
		status = @gojira.issue_status issue.key
		priority = @gojira.issue_priority issue.key

		"#{issue.key} - #{issue.summary} \n #{status[:name]} - #{priority[:name]} \n #{issue.description if verbose}"
	end

	def format_action(action)
		"#{action[:name]}"
	end

	def externalize_issue(key)
		@gojira.user_issues[key.to_i].key
	end

	def parse_args(args)
		command = args[0]
		case command
			when /i/
				then show_issues args[1]
			when /pr/
				then show_projects
			when /up/
				then update_status args[1], args[2]
			else
				show_issues
		end
	end
end



gj = Gojira.new "http://sandbox.onjira.com", "gojira", "gojira" #TODO parse config file, init and run
gj.run ARGV
