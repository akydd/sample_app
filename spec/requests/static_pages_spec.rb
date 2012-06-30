require 'spec_helper'

describe "Static Pages" do

  subject { page }

  describe "Home Page" do
    before { visit root_path }
    it { should have_selector('title', content: full_title('')) }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render a user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end
  end

  describe "Help Page" do
    before { visit help_path }
    it { should have_selector('title', content: full_title('Help')) }
  end

  describe "About page" do
    before { visit about_path }
    it { should have_selector('title', content: full_title('About')) }
  end

  describe "Contact page" do
    before { visit contact_path }
    it { should have_selector('title', :content => full_title('Contact')) }
  end
end
