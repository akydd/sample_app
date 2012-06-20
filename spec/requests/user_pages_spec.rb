require 'spec_helper'

describe "User Pages" do
	subject { page }

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
				expect { click_button "Sign up" }.not_to change(User, :count)
			end
		end

		describe "after submission" do
			before { click_button "Sign up" }

			it { should have_selector('title', content: full_title("Sign up")) }
			it { should have_content('error') }
		end

		describe "with valid info" do
			before do
				fill_in "Name", with: "Example User"
				fill_in "Email", with: "user@example.com"
				fill_in "Password", with: "foobar"
				fill_in "Confirmation", with: "foobar"
			end

			it "should create a new user" do
				expect { click_button "Sign up" }.to change(User, :count).by(1)
			end

			describe "after saving the user" do
				before { click_button "Sign up"}
				let(:user) { User.find_by_email('user@example.com') }

				it { should have_selector('title', text: user.name) }
				it { should have_selector('div', text: "Welcome") }
			end
		end
	end
end
