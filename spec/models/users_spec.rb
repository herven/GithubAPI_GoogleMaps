require 'spec_helper'

describe 'scopes' do  
  it "returns an array of results that match" do
    smith = User.create(:login => "smith", :location => "san diego", :repos => ['rails', 'capybara'])
    johnson = User.create(:login => "johnson", :location => "none", :repos => ['rails']) 
    jones = User.create(:login => "johnson", :location => "paris", :repos => ['capybara'])  
    User.with_location.should == [smith, jones]
    User.without_location.should == [johnson]
    User.by_repo('rails').should == [smith, johnson]
    User.with_location.by_repo('rails').should == [smith]
  end
end