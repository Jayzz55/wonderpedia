class CollaboratorsController < ApplicationController
  respond_to :html, :js

  def index
    @wiki = Wiki.find(params[:wiki_id])
    @collaborator = @wiki.collaborators
    @user = User.where.not(id: current_user.id)
    @collaborators_name = @wiki.users.each{|u| puts u.name}
  end

  def update_multiple
    if params[:users].present?
      captured_user_ids = params[:users].map{|a| a.to_i}
      user_ids = captured_user_ids << current_user.id
      wiki = Wiki.find(params[:wiki_id])
      collaborators_to_delete = wiki.collaborators.where.not(user_id: user_ids)
      collaborators_to_delete.destroy_all
      existing_collaborator_user_ids = wiki.collaborators.pluck(:user_id)
      new_user_ids = user_ids - existing_collaborator_user_ids
      new_user_ids.each do |c|
        wiki.collaborators.create(user_id: c)
      end
    else
      user_ids = current_user.id
      wiki = Wiki.find(params[:wiki_id])
      collaborators_to_delete = wiki.collaborators.where.not(user_id: user_ids)
      collaborators_to_delete.destroy_all
    end
    
    flash[:notice] = "Collaborators successfully updated."

    respond_with(@wiki) do |format|
      format.html { redirect_to wiki_collaborators_path(wiki)}
    end

  end

end