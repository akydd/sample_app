require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as current user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.should change(Micropost, :count).by(-1)
      end
    end
  end

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Submit" }.should_not change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Submit" }
        it { should have_error_message("Content can't be blank") }
      end
    end

    describe "with valid info" do

      before { fill_in 'command', with: "Lorem ipsum" }

      it "should create a micropost" do
        expect { click_button "Submit" }.should change(Micropost, :count).by(1)
      end

    end
  end

  describe "using the micropost form for following" do
    before { visit root_path }

    describe "follow a user not currently followed" do
      let(:other_user) { FactoryGirl.create(:user, username: "not_followed") }
      before { fill_in 'command', with: "follow not_followed" }

      it "should increment the followed user count" do
        expect do
          click_button "Submit"
        end.to change(user.followed_users, :count).by(1)
      end
    end

    describe "unfollow a user currently being followed" do
      let(:other_user) { FactoryGirl.create(:user, username: "other_user") }
      let(:relationship) { user.relationships.build(followed_id: other_user.id) }

      before { fill_in 'command', with: "unfollow other_user" }

      it "should decrement the followed user count" do
        expect do
          click_button "Submit"
        end.to change(user.followed_users, :count).by(-1)
      end
    end

    describe "follow yourself" do
      before { fill_in 'command', with: "follow #{user.username}" }

      it "should not increment the followed user count" do
        expect { click_button "Submit" }.should_not change(Relationship, :count)
      end

      describe "error message" do
        before { click_button "Submit" }
        it { should have_error_message("You cannot follow yourself!") }
      end
    end

    describe "follow a user that does not exist" do
      before { fill_in 'command', with: "follow does_not_exist" }

      it "should not increment the followed user count" do
        expect { click_button "Submit" }.should_not change(Relationship, :count)
      end

      describe "error message" do
        before { click_button "Submit" }
        it { should have_error_message("User to follow does not exist!") }
      end
    end

    describe "unfollow a user that is not being followed" do
      let(:not_followed) { FactoryGirl.create(:user, username: "not_followed") }

      before { fill_in 'command', with: "unfollow #{not_followed.username}" }

      it "should decrement the followed user cout" do
        expect { click_button "Submit" }.should_not change(Relationship, :count)
      end

      describe "error message" do
        before {click_button "Submit" }
        it { should have_error_message("You are not following that user!") }
      end
    end

  end
end
