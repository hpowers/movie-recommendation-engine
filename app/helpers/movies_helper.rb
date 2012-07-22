module MoviesHelper

# limit score to 99 in views
def view_score(score)
  score = 99 if score > 99
  score
end

end
