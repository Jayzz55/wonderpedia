class CollaboratorsController < ApplicationController
  respond_to :html, :js

  before_action :authenticate_user!

  def index
    @wiki = Wiki.friendly.find(params[:wiki_id])
    @user = User.where.not(id: current_user.id)
  end

  def update_multiple
    wiki = Wiki.friendly.find(params[:wiki_id])
    captured_params = params[:users]
    authorize wiki

    wiki.update_collaboration(captured_params, current_user)

    flash[:notice] = "Collaborators successfully updated."

    respond_with(@wiki) do |format|
      format.html { redirect_to wiki_collaborators_path(wiki)}
    end

  end

end