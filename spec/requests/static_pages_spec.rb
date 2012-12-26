require 'spec_helper'

describe "Static Pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('title',  text: fill_title(page_title)) }
    it { should have_selector('h1', text: heading) }
  end

  describe "Home Page" do
    before { visit root_path }
    let(:page_title) { '' }
    let(:heading) { 'Sample App' }
    it { should_not have_selector('title', text: 'Home') }

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
    let(:page_title) { 'Help' }
    let(:heading) { 'Help' }
  end

  describe "About page" do
    before { visit about_path }
    let(:page_title) { 'About' }
    let(:heading) { 'About ' }
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:page_title) { 'Contact' }
    let(:heading) { 'Contact' }
  end

  it "should have the correct links" do
    visit root_path
    click_link 'About'
    page.should have_selector('h1', text: 'About Us')
    click_link 'Help'
    page.should have_selector('h1', text: 'Help')
    click_link 'Contact'
    page.should have_selector('h1', text: 'Contact')
    click_link 'Home'
    page.should have_selector('h1', text: 'Sample App')
    click_link 'Sign in'
    page.should have_selector('h1', text: 'Sign In')
  end
end
