class Mission
  # Collection of methods to control the Mission states
  module StateMachine
    def accept(member)
      update(assignee: member, status: 'accepted') && sync_post!
    end

    def submit
      # If a user has a trusted role, auto-approve submission 90% of the time.
      # The 10% is just a sample to be audited to prevent abuse
      return approve if assignee.trusted? && rand > 0.1

      delete_post! && submitted! && reload && sync_post!
    end

    def abandon
      delete_post! && update(assignee: nil, status: 'active') && reload && sync_post!
    end

    def cancel
      delete_post! && update(assignee: nil, status: 'completed', title: "[CANCELLED] #{title}") && reload && sync_post!
    end

    def reject(feedback: nil)
      Reject.call(mission: self, feedback:)
    end

    def approve
      Approve.call(self)
    end
  end
end
