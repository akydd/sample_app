require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "using the micropost form for sending messages" do
    before { visit root_path }

    describe "send a message to user who is not following you" do
      let(:other_user) { FactoryGirl.create(:user, username: "not_following") }
      before { fill_in 'command', with: "dm #{other_user.username} message" }

      it "should not create a new message" do
        expect { click_button "Submit" }.not_to change(Message, :count)
      end

      describe "error message" do
        before { click_button "Submit" }
        it { should have_error_message("Recipient is not following you!") }
      end
    end

    describe "send a message to a user who does not exist" do
      before { fill_in 'command', with: "dm does_not_exist message" }

      it "should not create a new message" do
        expect { click_button "Submit" }.not_to change(Message, :count)
      end

      describe "error message" do
        before { click_button "Submit" }
        it { should have_error_message("Recipient does not exist!") }
      end
    end

    describe "send a message to self" do
      before { fill_in 'command', with: "dm #{user.username} message" }

      it "should not create a message" do
        expect { click_button "Submit" }.not_to change(Message, :count)
      end

      describe "error message" do
        before { click_button "Submit" }
        it { should have_error_message("You cannot send a message to yourself!") }
      end
    end

    describe "send a valid message" do
      let(:other_user) { FactoryGirl.create(:user) }
      before do
        other_user.follow!(user)
        fill_in 'command', with: "dm #{other_user.username} message txt"
      end

      it "should create a new message" do
        expect { click_button "Submit" }.to change(Message, :count).by(1)
      end

      it "should increment user's sent_message count" do
        expect do
          click_button "Submit"
        end.to change(user.sent_messages, :count).by(1)
      end

      it "should increment other_user's received_message count" do
        expect do
          click_button "Submit"
        end.to change(other_user.received_messages, :count).by(1)
      end
    end

  end

  describe "using the micropost form for following" do
    before { visit root_path }

    describe "follow a user not currently followed" do
      let(:other_user) { FactoryGirl.create(:user, username: "not_followed") }
      before { fill_in 'command', with: "follow #{other_user.username}" }

      it "should increment the followed user count" do
        expect do
          click_button "Submit"
        end.to change(user.followed_users, :count).by(1)
      end
    end

    describe "unfollow a user currently being followed" do
      let(:other_user) { FactoryGirl.create(:user, username: "other_user") }

      before do
        user.follow!(other_user)
        fill_in 'command', with: "unfollow #{other_user.username}"
      end

      it "should decrement the followed user count" do
        expect do
          click_button "Submit"
        end.to change(user.followed_users, :count).by(-1)
      end
    end

    describe "follow yourself" do
      before { fill_in 'command', with: "follow #{user.username}" }

      it "should not increment the followed user count" do
        expect { click_button "Submit" }.not_to change(Relationship, :count)
      end

      describe "error message" do
        before { click_button "Submit" }
        it { should have_error_message("You cannot follow yourself!") }
      end
    end

    describe "follow a user that does not exist" do
      before { fill_in 'command', with: "follow does_not_exist" }

      it "should not increment the followed user count" do
        expect { click_button "Submit" }.not_to change(Relationship, :count)
      end

      describe "error message" do
        before { click_button "Submit" }
        it { should have_error_message("User to follow does not exist!") }
      end
    end

    describe "unfollow a user that is not being followed" do
      let(:not_followed) { FactoryGirl.create(:user, username: "not_followed") }

      before { fill_in 'command', with: "unfollow #{not_followed.username}" }

      it "should decrement the followed user count" do
        expect { click_button "Submit" }.not_to change(Relationship, :count)
      end

      describe "error message" do
        before {click_button "Submit" }
        it { should have_error_message("You are not following #{not_followed.username}!") }
      end
    end

  end
end
