require 'spec_helper'
require 'capybara/rspec'

describe "Authentication" do

  subject { page }

  describe "authorization" do

    describe "for non-signed in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Relationships controller" do
        describe "submitting to the create action" do
          before { post relationships_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete relationship_path(1) }
          specify { response.should redirect_to(signin_path) }
        end
      end

      describe "in the Parsers controller" do

        describe "submitting to the create action" do
          before { post parser_index_path }
          specify { response.should redirect_to(signin_path) }
        end
      end

      describe "in the Microposts controller" do

        describe "submitting to the destory action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { response.should redirect_to(signin_path) }
        end
      end

      describe "in the User controller" do

        describe "submitting to the update action" do
          # need to 'put' here because there is no way for a browser to visit
          # the update action directly
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "submitting PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "as admin user" do
      let(:admin) { FactoryGirl.create(:admin) }

      before { sign_in admin }

      describe "submitting a DELETE request to the Users#destory action" do
        before { delete user_path(admin) }
        it { should redirect_to(users_path) }
        it { should have_error_message("Admin user cannot delete self!") }
        it { should_not change(User, :count) }
      end
    end
  end
end
