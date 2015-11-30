module VotesHelper

  def vote?(agent, value)
    if current_user.vote_to_agents.include?(agent)
      if current_user.latest_agent_votes.where(:agent=>agent, :value=>value).present?
        "btn-success"
      else
        "btn-default"
      end
    else
      "btn-default"
    end
  end

end
