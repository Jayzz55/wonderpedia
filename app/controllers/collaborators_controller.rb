class CollaboratorsController < ApplicationController
  def index
    @wiki = Wiki.find(params[:wiki_id])
    @collaborator = Collaborator.new
    @user = User.where.not(id: current_user.id)
  end
end