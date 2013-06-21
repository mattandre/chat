require 'spec_helper'

describe "Pages" do

  describe "Home page" do

    it "should have the content 'Live Chat'" do
      visit '/pages/home'
      expect(page).to have_content('Live Chat')
    end

    it "should have the title 'Home'" do
    	visit '/pages/home'
    	expect(page).to have_title('Home')
    end

  end

  describe "Help page" do

    it "should have the content 'Help'" do
      visit '/pages/help'
      expect(page).to have_content('Help')
    end

    it "should have the title 'Help'" do
      visit '/pages/help'
      expect(page).to have_title('Help')
    end

  end

  describe "About page" do

    it "should have the content 'About'" do
      visit '/pages/about'
      expect(page).to have_content('About')
    end

    it "should have the title 'About'" do
      visit '/pages/about'
      expect(page).to have_title('About')
    end

  end

end
