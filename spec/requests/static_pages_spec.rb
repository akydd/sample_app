require 'spec_helper'

describe "Static Pages" do

	subject { response }

	describe "Home Page" do
		before { visit root_path }
		it { should have_selector('title', content: full_title('')) }
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
