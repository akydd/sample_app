require 'spec_helper'

describe "Authentication" do

	subject { response }

	describe "signin page" do
		before { visit signin_path }
		it { should have_selector('title', content: 'Sign In') }
	end

	describe "signin" do
		before { visit signin_path }

		describe "with invalid info" do
			before { click_button "Sign in" }

			it { should have_selector('title', content: 'Sign In') }
			it { should have_selector('div', content: 'Invalid') }
		end

		describe "with valid info" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				fill_in "Email", with: user.email
				fill_in "Password", with: user.password
				click_button "Sign in"
			end

			it { should have_selector('title', content: user.name) }
			it { should have_link('Profile', href: user_path(user)) }
			it { should have_link('Sign Out', href: signout_path) }
			it { should_not have_link('Sign In', href: signin_path) }
		end
	end
end
