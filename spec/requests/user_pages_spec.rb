require 'spec_helper'

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
  end
end
