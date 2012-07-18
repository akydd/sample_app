require 'spec_helper'

describe Message do
  let(:from_user) { FactoryGirl.create(:user) }
  let(:to_user) { FactoryGirl.create(:user) }

  before do
    @message = from_user.sent_messages.build(content: "Lorem ipsum",
                                             to_user_id: to_user.id)
  end

  subject { @message }

  it { should respond_to(:content) }
  it { should respond_to(:to_user_id) }
  it { should respond_to(:from_user_id) }
  its(:sender) { should == from_user }
  its(:recipient) { should == to_user }

  it { should be_valid}

  describe "when to_user_id is not present" do
    before { @message.to_user_id = nil }
    it { should_not be_valid }
  end

  describe "when from_user_id is not present" do
    before { @message.from_user_id = nil }
    it { should_not be_valid }
  end

  describe "when content is not present" do
    before { @message.content = nil }
    it { should_not be_valid }
  end

  describe "accessible attribute" do
    it "should not allow access to from_user_id" do
      expect do
        Message.new(from_user_id: from_user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

  end
end
