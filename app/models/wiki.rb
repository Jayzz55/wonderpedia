class Wiki < ActiveRecord::Base
  has_many :users, through: :collaborators
  has_many :collaborators

  default_scope { order('created_at DESC') }

  def self.viewable(user)
    wiki_collab = Collaborator.where(user_id: user.id)
    select_wiki = Wiki.where(id: wiki_collab.pluck(:wiki_id), :private => true)
    public_wiki = Wiki.where(:private => false)
    return select_wiki + public_wiki
  end

  def premium_access?(user)
    user.premium == true && self.users.first == user
  end

  def check_exist?(user)
    if self.users.include? user
      return true
    else
      return false
    end
  end

  def collaborators_name
    name =[]
    self.users.each{|u| name << u.name}
    return name.join(',')
  end
  
end
