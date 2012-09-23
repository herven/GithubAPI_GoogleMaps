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
    page.should have_css('.map_container')
    page.should have_css('#chart')
  end
end

describe 'form post with bad value' do
  it 'redirect to root when bad value' do
    visit root_path
    fill_in 'user', :with => 'toto'
    fill_in 'repo', :with => 'tata'
    click_button 'Submit'
    current_path.should eq root_path
    page.should have_css('#error')
  end
end


