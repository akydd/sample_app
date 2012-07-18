require 'spec_helper'

describe User do

  before(:each) do
    @user = User.new(username: "exampleuser", name: "Example User",
                     email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:username) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }
  it { should respond_to(:sent_messages) }
  it { should respond_to(:received_messages) }

  it { should be_valid }
  it { should_not be_admin }

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end

    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end

  describe "with admin attribute set to 'true'" do
    before { @user.toggle!(:admin) }

    it { should be_admin }
  end

  describe "when username is not present" do
    before { @user.username = " " }
    it { should_not be_valid }
  end

  describe "when name is not present" do
    before  { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email address is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when username is too long" do
    before { @user.username = "a" * 16 }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email address is valid" do
    it "should be valid" do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  describe "when invalid email address" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe "when username is valid" do
    it "should be valid" do
      usernames = %w[goodName _the_user_ HEYDUDE smallcaps 1234]
      usernames.each do |valid_username|
        @user.username = valid_username
        @user.should be_valid
      end
    end
  end

  describe "when username is invalid" do
    it "should not be valid" do
      usernames = [ '', ' ', '!#$^', 'm!x3d73tter$' ]
      usernames.each do |invalid_username|
        @user.username = invalid_username
        @user.should_not be_valid
      end
    end
  end

  describe "when duplicate (up to case) username is taken" do
    before do
      user_with_duplicate_email = @user.dup
      # avoid duplicate email validation error
      user_with_duplicate_email.email = "new@email.com"
      user_with_duplicate_email.save
    end
    it { should_not be_valid }
  end

  describe "when duplicate (up to case) email is taken" do
    before do
      user_with_duplicate_name = @user.dup
      # avoid duplicate username validation
      user_with_duplicate_name.username = "AnotherName"
      user_with_duplicate_name.save
    end
    it { should_not be_valid }
  end

  describe "return val of autenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_username(@user.username) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end

  describe "micropost associations" do

    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      @user.microposts.should == [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
      microposts = @user.microposts
      @user.destroy
      microposts.each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end

    describe "status feed" do

      # this post shouldn't be in @user's feed
      let(:unfollowed_user_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      
      # this post should be in @user's feed, as it's a reply to @user
      # even though it's not from a following/followed user
      let(:reply_to_user) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user),
                           in_reply_to: @user)
      end

      let(:followed_user) { FactoryGirl.create(:user) }
      let(:followed_user_post) do
        followed_user.microposts.create!(content: "Lorem ipsum")
      end
      let(:reply_to_followed_user) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user),
                           in_reply_to: followed_user)
      end

      before do
        @user.follow!(followed_user)
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_user_post) }
      its(:feed) { should include(followed_user_post) }
      its(:feed) { should include(reply_to_followed_user) }
      its(:feed) { should include(reply_to_user) }
    end
  end

  describe "when password is missing" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password confirmation does not match" do
    before { @user.password_confirmation = "barfoo" }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should_not be_valid }
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { 'MiXeD@email.com' }

    it "should be saved in lower case" do
      @user.email = mixed_case_email
      @user.save
      @user.reload.email.should == mixed_case_email.downcase
    end
  end

  describe "default sort order" do

    # use let! here so that FactoryGirl is 'forced' to save objs in db
    let!(:anakin) { FactoryGirl.create(:user, username: "AnakinSkywalker") }
    let!(:yoda) { FactoryGirl.create(:user, username: "Yoda") }
    let!(:maul) { FactoryGirl.create(:user, username: "DarthMaul") }
    let!(:vader) { FactoryGirl.create(:user, username: "DarthVader") }

    it "should be alphabetically by username" do
      User.all.should == [anakin, maul, vader, yoda]
    end
  end

  describe "messages ordering" do
    let(:recipient) { FactoryGirl.create(:user) }

    before do
      @user.save
    end

    let!(:old_msg) do
      FactoryGirl.create(:message, sender: @user, recipient: recipient,
                         created_at: 1.day.ago)
    end
    let!(:new_msg) do
      FactoryGirl.create(:message, sender: @user, recipient: recipient,
                         created_at: 1.hour.ago)
    end

    it "should order the sent msgs with newest first" do
      @user.sent_messages.should == [new_msg, old_msg]
    end

    it "should order the received msgs with newest first" do
      recipient.received_messages.should == [new_msg, old_msg]
    end
  end

end
