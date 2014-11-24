require 'rails_helper'

describe CollaboratorsController do

  it "prevent an attacker update collaborators", focus: true do
    user = create(:user, premium: true)
    attacker = create(:user)
    private_wiki = create(:wiki_with_user, :private => true, user: user)
    sign_in attacker

    put :update_multiple, wiki_id: "test-one", users: [attacker.id]

    expect( private_wiki.users.count).to eq(1)
  end

end