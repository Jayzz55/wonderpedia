class WikisController < ApplicationController
  respond_to :html, :js

  def index
    @wikis = Wiki.all

  end

  def show

  end

  def new
    @new_wiki = current_user.wikis.build
    
  end

  def create
    
    @wiki = current_user.wikis.build(wiki_params)

    if @wiki.save
      flash[:notice] = "Wiki successfully created."
    else
      flash[:error] = "There was an error creating the wiki. Please try again."
    end

    respond_with(@wiki) do |format|
      format.html { redirect_to wikis_path}
    end

  end

  def edit
  end

  def update
  end

  def destroy

  end

  private

  def wiki_params
    params.require(:wiki).permit(:title, :body)
  end
end
