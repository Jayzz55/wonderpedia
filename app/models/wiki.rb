class Wiki < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :users, through: :collaborators
  has_many :collaborators

  # default_scope { order('wikis.created_at DESC') }
  default_scope { order(created_at: :desc) }

  validates :body, length: { minimum: 5 }, presence: true
  validates :title, length: { minimum: 5 }, presence: true

  def self.viewable(user)
    Wiki.includes(:collaborators).where(
      "private = ? OR (private = ? AND collaborators.user_id = ?)", 
      false, true, user.id
    ).references(:collaborators)

    # This is only for information of the old code.
    # wiki_collab = Collaborator.where(user_id: user.id)
    # select_wiki = Wiki.where(id: wiki_collab.pluck(:wiki_id), :private => true)
    # public_wiki = Wiki.where(:private => false)
    # return select_wiki + public_wiki
  end

  def premium_access?(user)
    user.premium && self.is_creator?(user) && self.private
  end

  def is_creator?(user)
    self.users.first == user
  end

  def check_user_exist?(user)
    self.users.include? user
  end

  def collaborators_name
    name =[]
    self.users.each{|u| name << u.name}
    return name.join(',')
  end

  def update_collaboration(captured_params, current_user)
    if captured_params.present?
      captured_user_ids = captured_params.map{|a| a.to_i}
      user_ids = captured_user_ids << current_user.id
      collaborators_to_delete = self.collaborators.where.not(user_id: user_ids)
      collaborators_to_delete.destroy_all
      existing_collaborator_user_ids = self.collaborators.pluck(:user_id)
      new_user_ids = user_ids - existing_collaborator_user_ids
      new_user_ids.each do |c|
        self.collaborators.create(user_id: c)
      end
    else
      user_ids = current_user.id
      collaborators_to_delete = self.collaborators.where.not(user_id: user_ids)
      collaborators_to_delete.destroy_all
    end
  end
  
end
