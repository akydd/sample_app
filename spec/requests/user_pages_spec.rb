require 'spec_helper'

describe "User Pages" do
	subject { response }

	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }

		it { should have_selector('title', content: user.name) }
	end

	describe "signup page" do
		before { visit signup_path }

		it { should have_selector('h1',	content: "Sign up") }
		it { should have_selector('title', content: full_title("Sign up")) }
	end

	describe "signup" do
		before { visit signup_path }

		describe "with invalid info" do
			it "should not create a user" do
				expect { click_button }.not_to change(User, :count)
			end
		end

		describe "with valid info" do
			before do
				fill_in "Name", with: "Example User"
				fill_in "Email", with: "user@example.com"
				fill_in "Password", with: "foobar"
				fill_in "Confirmation", with: "foobar"
			end

			it "should create a new user" do
				expect { click_button }.to change(User, :count).by(1)
			end
		end
	end
end
