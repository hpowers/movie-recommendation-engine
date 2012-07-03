require 'spec_helper'
# require 'capybara/rspec'


describe "default page" do

  before do

    movie = Movie.create!({title:'Bloc X: Bloc in Space', 
          score: 70, released: true, default: true}, :without_protection => true)

    rotten = RtDatum.find_or_create_by_movie_id( movie.id )
    rotten.critics_consensus = 'good'
    rotten.save

    movie = Movie.create!({title:'Bloc III: Return of Bloc', 
          score: 95, released: true, default: true}, :without_protection => true)

    rotten = RtDatum.find_or_create_by_movie_id( movie.id )
    rotten.critics_consensus = 'good'
    rotten.save

    movie = Movie.create!({title:'Bloc II: Bloc to the future', 
          score: 90, released: true, default: true}, :without_protection => true)

    rotten = RtDatum.find_or_create_by_movie_id( movie.id )
    rotten.critics_consensus = 'good'
    rotten.save
    
  end

  before {}
  
  it "redirect to the top ranked movie" do
    visit '/'
    # save_and_open_page
    page.should have_content('you should see ...')
    page.should have_content('Bloc III: Return of Bloc')
  end

end