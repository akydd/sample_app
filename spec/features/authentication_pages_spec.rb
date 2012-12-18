require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }
    it { should have_selector('h1', text: 'Sign In') }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid info" do
      before { click_button "Sign in" }

      it { should have_selector('h1', text: 'Sign In') }
      it { should have_error_message('Invalid') } 

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_error_message('Invalid') }
      end
    end

    describe "with valid info" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_selector('h1', text: user.username) }
      it { should have_link('Users', href: users_path) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sent', href: messages_from_user_path(user)) }
      it { should have_link('Received', href: messages_to_user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign In', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link("Sign in") }
      end
    end
  end

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

        #describe "submitting to the create action" do
        #  before { post microposts_path }
        #  specify { response.should redirect_to(signin_path) }
        #end

        describe "submitting to the destory action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { response.should redirect_to(signin_path) }
        end
      end

      describe "when attemping to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Username", with: user.username
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            page.should have_selector('h1', text: 'Update your profile')
          end
        end
      end

      describe "in the User controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('h1', text: 'Sign In') }
        end

        describe "submitting to the update action" do
          # need to 'put' here because there is no way for a browser to visit
          # the update action directly
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector('h1', text: 'Sign In') }
        end

        describe "visiting the following page" do
          before { visit following_user_path(user) }
          it { should have_selector('h1', text: 'Sign In') }
        end

        describe "visiting the followers page" do
          before { visit followers_user_path(user) }
          it { should have_selector('h1', text: 'Sign In') }
        end

        describe "visiting the messages_to page" do
          before { visit messages_to_user_path(user) }
          it { should have_selector('h1', text: 'Sign In') }
        end

        describe "visiting the messages_from page" do
          before { visit messages_from_user_path(user) }
          it { should have_selector('h1', text: 'Sign In') }
        end

        describe "after signing in" do

          before { sign_in user }

          describe "create a new user" do
            before { post users_path }
            specify { response.should redirect_to(root_path) }
          end

          describe "page to make a new user" do
            before { get new_user_path }
            specify { response.should redirect_to(root_path) }
          end
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting the edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: full_title('Edit User')) }
      end

      describe "visiting the messages_to page" do
        before { visit messages_to_user_path(wrong_user) }
        it { should_not have_selector('title', text: full_title('Received Messages')) }
      end

      describe "visiting the messages_from page" do
        before { visit messages_from_user_path(wrong_user) }
        it { should_not have_selector('title', text: full_title('Sent Messages')) }
      end

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
  end
end