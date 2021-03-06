class WikisController < ApplicationController
  respond_to :html, :js

  before_action :authenticate_user!

  def index
    @wikis = Wiki.viewable(current_user)

  end

  def show
    @wiki = Wiki.friendly.find(params[:id])
  end

  def new
    @new_wiki = current_user.wikis.build
    
  end

  def create
    @wiki = current_user.wikis.create(wiki_params)

    if @wiki.persisted?
      flash[:notice] = "Wiki successfully created."
    else
      flash[:error] = "There was an error creating the wiki. Please try again."
    end

    respond_with(@wiki) do |format|
      format.html { redirect_to wikis_path}
    end

  end

  def edit
    @wiki = Wiki.friendly.find(params[:id])
    authorize @wiki

  end

  def update
    @wiki = Wiki.friendly.find(params[:id])
    authorize @wiki

    if @wiki.update_attributes(wiki_params)
      flash[:notice] = "Wiki successfully updated."
    else
      flash[:error] = "There was an error updating the wiki. Please try again."
    end

    respond_with(@wiki) do |format|
      format.html { redirect_to wikis_path}
    end
  end

  def destroy
    @wiki = Wiki.friendly.find(params[:id])
    authorize @wiki

    if @wiki.destroy
      flash[:notice] = "Wiki was successfully removed"
    else
      flash[:error] = "Wiki couldn't be deleted. Try again."
    end

    respond_with(@wiki) do |format|
      format.html{ redirect_to wikis_path}
    end

  end

  private

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end
end
