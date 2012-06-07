require 'spec_helper'

describe "Microposts" do

  before(:each) do
    user = FactoryGirl.create(:user)
    visit signin_path
    fill_in :email, :with => user.email
    fill_in :password, :with => user.password
    click_button
  end

  describe "sidebar micropost counts" do

    describe "for 0 microposts" do

      it "should list '0 microposts'" do
        visit root_path
        response.should have_selector("span", :content => "0 microposts")
      end
    end

    describe "for 1 micropost" do

      it "should list '1 micropost'" do
        visit root_path
        fill_in :micropost_content, :with => "Lorem ipsum dolor sit"
        click_button
        response.should have_selector("span", :content => "1 micropost")
      end
    end

    describe "for more that 1 microposts" do

      it "should say '2 microposts'" do
        visit root_path
        fill_in :micropost_content, :with => "Here is the first post"
        click_button
        fill_in :micropost_content, :with => "Here is another post"
        click_button
        response.should have_selector("span", :content => "2 microposts")
      end
    end

  end

  describe "creation" do
  
    describe "failure" do

      it "should not make a new micropost" do
        lambda do
          visit root_path
          fill_in :micropost_content, :with => ""
          click_button
          response.should render_template('pages/home')
          response.should have_selector("div#error_explanation")
        end.should_not change(Micropost, :count)
      end
    end

    describe "success" do

      it "should make a new micropost" do
        content = "Lorem ipsum dolor sit ammet"
        lambda do
          visit root_path
          fill_in :micropost_content, :with => content
          click_button
          response.should have_selector("span.content", :content => content)
        end.should change(Micropost, :count).by(1)
      end
    end
    
  end

end
