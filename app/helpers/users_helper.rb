module UsersHelper
  def create_events_stats(events)
    n = events.count 
    commit  = []
    create  = []
    delete  = []
    download  = []
    follow  = []
    fork  = []
    fork_apply  = []
    gist  = []
    gollum  = []
    issue  = []
    issue_comment  = []
    member  = []
    public  = []
    pull  = []
    team  = []
    watch  = []
    push  = []
    pull_review  = []
    events.each do |event|
      if event.type == 'CommitCommentEvent'
        commit << event
      elsif event.type == 'CreateEvent'
        create << event
      elsif event.type == 'DeleteEvent'
        delete << event
      elsif event.type == 'DownloadEvent'
        download << event
      elsif event.type == 'FollowEvent'
        commit << event
      elsif event.type == 'ForkEvent'
        fork << event
      elsif event.type == 'ForkApplyEvent'
        fork_apply << event
      elsif event.type == 'GistEvent'
        gist << event
      elsif event.type == 'GollumEvent'
        gollum << event
      elsif event.type == 'IssuesEvent'
        issue << event
      elsif event.type == 'MemberEvent'
        member << event
      elsif event.type == 'IssueCommentEvent'
        issue_comment << event
      elsif event.type == 'PublicEvent'
        public << event
      elsif event.type == 'PullRequestEvent'
        pull << event
      elsif event.type == 'PullRequestReviewCommentEvent'
        pull_review << event
      elsif event.type == 'PushEvent'
        push << event
      elsif event.type == 'TeamAddEvent'
        team << event
      elsif event.type == 'WatchEvent'                                                                                                                               
        watch << event  
      end
    end
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Type' ) 
    data_table.new_column('number', 'Values')     

    data_table.add_rows([ ['CommitCommentEvent', commit.count*100/n],['CreateEvent', create.count*100/n],['DeleteEvent', delete.count*100/n],
                          ['DownloadEvent', download.count*100/n],['FollowEvent', follow.count*100/n],['ForkEvent', fork.count*100/n],
                          ['ForkApplyEvent', fork_apply.count*100/n],['GistEvent', gist.count*100/n],['GollumEvent', gollum.count*100/n],
                          ['IssueCommentEvent', issue_comment.count*100/n],['IssuesEvent', issue.count*100/n],['MemberEvent', member.count*100/n],
                          ['PublicEvent', public.count*100/n],['PullRequestEvent', pull.count*100/n],['PullRequestReviewCommentEvent', pull_review.count*100/n],
                          ['PushEvent', push.count*100/n],['TeamAddEvent', team.count*100/n],['WatchEvent', watch.count*100/n] ])
    option = { width: 400, height: 500, title: 'Last events graph' }
    @chart = GoogleVisualr::Interactive::BarChart.new(data_table, option) 
    return @chart    
  end
end
