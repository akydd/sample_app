require 'spec_helper'

describe "User Pages" do

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
end
