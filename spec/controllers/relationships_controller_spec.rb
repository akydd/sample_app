require 'spec_helper'

describe RelationshipsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }

  describe "for non-signed in user" do
    describe "submitting to the create action" do
      before { post :create }
      specify { response.should redirect_to(signin_path) }
    end

    describe "submitting to the destroy action" do
      before do
        user.follow!(other_user)
        @relationship = user.relationships.find_by_followed_id(other_user)
        delete :destroy, id: @relationship.id
      end
      specify { response.should redirect_to(signin_path) }
    end
  end

  describe "for signed in users" do
    before { sign_in user }

    describe "creating a relationship with Ajax" do

      it "should increment the Relationship count" do
        expect do
          xhr :post, :create, relationship: { followed_id: other_user.id }
        end.to change(Relationship, :count).by(1)
      end

      it "should respond with success" do
        xhr :post, :create, relationship: { followed_id: other_user.id }
        response.should be_success
      end
    end

    describe "destroying a relationship with Ajax" do

      before { user.follow!(other_user) }
      let(:relationship) { user.relationships.find_by_followed_id(other_user) }

      it "should decrement the Relationship count" do
        expect do
          xhr :delete, :destroy, id: relationship.id
        end.to change(Relationship, :count).by(-1)
      end

      it "should respond with success" do
        xhr :delete, :destroy, id: relationship.id
        response.should be_success
      end
    end
  end
end
