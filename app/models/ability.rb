class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, ActiveAdmin::Page, name: 'Dashboard'

    case user.mentat_role.to_sym
    when :superadmin
      # superusers can do everything, no need to specify
      can :manage, :all
    when :admin
      admin
      basic(user)
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

  def admin
    can :manage, :all
    cannot :manage, User
  end
end
