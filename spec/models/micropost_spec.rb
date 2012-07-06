require 'spec_helper'

describe Micropost do

  let(:user) { FactoryGirl.create(:user) }
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:in_reply_to) }
  it { should respond_to(:is_reply_to?) }
  its(:user) { should == user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank content" do
    before { @micropost.content = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end

  describe "when in_reply_to is empty" do
    its(:is_reply_to?) { should be_false }
  end

  describe "when in_reply_to is present" do
    let(:other_user) { FactoryGirl.create(:user) }
    before { @micropost.in_reply_to = other_user }
    its(:is_reply_to?) { should be_true }
  end

  describe "set_in_reply_to when post is a reply" do
    let(:other_user) { FactoryGirl.create(:user, username: 'other_user') }
    before { @micropost.content = '@other_user here is my reply' }
    its(:in_reply_to) { should == other_user } 
  end

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Micropost.new(user_id: user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
end
