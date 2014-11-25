require 'rails_helper'

describe Collaborator do
  context "association" do
    it {should belong_to(:user)}
    it {should belong_to(:wiki)}
  end
end
