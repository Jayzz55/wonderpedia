class CollaboratorsController < ApplicationController
  respond_to :html, :js

  def index
    @wiki = Wiki.find(params[:wiki_id])
    @collaborator = @wiki.collaborators
    @user = User.where.not(id: current_user.id)
  end

  def update_multiple
    wiki = Wiki.find(params[:wiki_id])
    captured_params = params[:users]

    wiki.checkbox_processing(captured_params, current_user)

    flash[:notice] = "Collaborators successfully updated."

    respond_with(@wiki) do |format|
      format.html { redirect_to wiki_collaborators_path(wiki)}
    end

  end

end