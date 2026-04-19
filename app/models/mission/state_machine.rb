class Mission
  # Collection of methods to control the Mission states
  module StateMachine
    def accept(member)
      update(assignee: member, status: 'accepted') && sync_post!
    end

    def submit
      delete_post! && submitted! && reload && sync_post!
    end

    def abandon
      delete_post! && update(assignee: nil, status: 'active') && reload && sync_post!
    end

    def cancel
      delete_post! && update(assignee: nil, status: 'completed', title: "[CANCELLED] #{title}") && reload && sync_post!
    end

    def reject
      Reject.call(self)
    end

    def approve
      Approve.call(self)
    end
  end
end
