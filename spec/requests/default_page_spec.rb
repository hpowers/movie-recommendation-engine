require 'spec_helper'

describe "default page" do

  before do
    50.times { FactoryGirl.create(:movie) }

    FactoryGirl.create(:movie, 
                        title: 'Bloc III: Return of Bloc',
                        score: 100)
  end


  it "references more than 50 movies"

  it "redirects to movies#index"

  it "shows the top ranking movie"

  it "links to the next movie"

  it "has a form for showtimes"
  
  it "redirect to the top ranked movie" do
    # puts "count: #{Movie.count}"
    visit '/'
    # save_and_open_page
    page.should have_content('you should see ...')
    page.should have_content('Bloc III: Return of Bloc')
  end

end