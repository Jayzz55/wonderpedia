class WikiPolicy < ApplicationPolicy

  def update_multiple?
    user.present? && (record.users.include? user)
  end
  
end