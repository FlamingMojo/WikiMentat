class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, ActiveAdmin::Page, name: 'Dashboard'

    case user.mentat_role.to_sym
    when :superadmin
      # superusers can do everything, no need to specify
      can :manage, :all
    when :admin
      basic(user)
      processing(user)
    when :standard
      basic(user)
    else
      nil
    end
  end


  private

  def basic(user)
    can :read, user.wiki_users
    can :read, user.user_claims
    can :read, user
  end

  def processing(user)
    # can :manage, Borrow

    # The conditions hash allows cancan to generate a query
    # to load accessible records as well as check individual
    # records.
    # can :manage, OtherThing, name: ['Reports', 'Categorize']
  end
end
