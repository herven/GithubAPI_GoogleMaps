require 'spec_helper'

describe 'home page' do
  it 'access the root page' do
    visit root_path
    page.should have_content('Welcome')
    page.should have_field "user"
    page.should have_field "repo"
    page.should have_button "Submit"
  end
end

describe 'app post action' do
  it 'lets the visitor post form' do
    visit root_path
    fill_in 'user', :with => 'rails'
    fill_in 'repo', :with => 'rails'
    click_button 'Submit'
    current_path.should eq show_commiters_users_path
    #page.should have_content('has been submitted')
    #page.should have_content('Awesome post!')
  end
end

#describe "Users" do
#  describe "GET /users" do
#    it "works! (now write some real specs)" do
#      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
#      get users_path
#      response.status.should be(200)
#    end
#  end
#end
