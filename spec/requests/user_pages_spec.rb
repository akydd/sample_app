require 'spec_helper'

####
# 
# Capybara 2 no longer "sees" the title, so it cannot check it.
# with have_selector('title', text: "text")
#
###

describe "User Pages" do
  subject { page }

  describe "message pages" do

    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    let(:msg_to) { FactoryGirl.build(:message, sender: other_user,
                                     recipient: user,
                                     content: "message to") }
    let(:msg_from) { FactoryGirl.build(:message, sender: user,
                                       recipient: other_user,
                                       content: "message from") }

    before do
      user.follow!(other_user)
      other_user.follow!(user)
      msg_to.save
      msg_from.save
      sign_in user
    end

    describe "messages to" do
      before do
        visit messages_to_user_path(user)
      end

      it { should have_selector("span.content", text: msg_to.content) }
      it { should have_content("Sent from") }
      it { should have_link(other_user.username, href: user_path(other_user)) }
    end

    describe "messages from" do
      before do
        visit messages_from_user_path(user)
      end

      it { should have_selector("span.content", text: msg_from.content) }
      it { should have_content("Sent to") }
      it { should have_link(other_user.username, href: user_path(other_user)) }
    end
  end

  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    describe "followed users" do
      before do
        sign_in user
        visit following_user_path(user)
      end

      it { should have_selector('h3', text: 'Following') }
      it { should have_link(other_user.username, href: user_path(other_user)) }
    end

    describe "followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end

      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(user.username, href: user_path(user)) }
    end
  end

  describe "index" do

    let(:user) { FactoryGirl.create(:user) }
    before(:all) { 30.times { FactoryGirl.create(:user) } }
    after(:all) { User.delete_all }

    before(:each) do
      sign_in user
      visit users_path
    end

    describe "pagination" do

      it { should have_selector('div.pagination') }

      it "should list all users" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.username)
        end
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

    before { visit user_path(user) }

    it { should have_selector('h1', text: user.username) }
    it { should have_selector('h4', text: user.name) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end

    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "following a user" do
        before { visit user_path(other_user) }

        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          it { should_not have_button "Follow" }
          it { should have_button "Unfollow" }
        end
      end

      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the other user's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should_not have_button("Unfollow") }
          it { should have_button("Follow") }
        end
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    it { should_not have_selector('label', text: "Username") }

    describe "with valid info" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }

      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirmation", with: user.password
        click_button "Update"
      end

      it { should have_selector('div', text: 'updated') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
      specify { user.reload.username.should == user.username}
    end
  end
end
