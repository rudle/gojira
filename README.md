# gojira
gojira is a command line interface to Atlassian Jira. It currently supports reading and updating of issues and comments. More features (search, comments) are planned.

## installation
'gem install gojira' should do the trick. This will install two executable links - 'gojira' and 'gj'.  
gojira will look for a config file at ~/.gojira  
expected format is:  
	full path to jira  
	username  
	password  

## usage
### commands:
*	gojira i[ssues] - show all issues assigned to you
*	gojira i[ssue] issue - show information about an issue with the given key
*	gojira p[rojects] - show all projects on the current Jira instance
*	gojira u[pdate] issue - show all valid actions that can be performed on an issue
*	gojira u[pdate] issue action_id - move the issue to the specified status

### arguments:
	issue => an internal gojira ID (ie. from 'gojira issues')
	action_id => an internal gojira action_ID (ie. from 'gojira update issue')
