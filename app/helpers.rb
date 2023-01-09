# application helpers
# Registers errors
def register_error(error_message)
  if session[:errors]
    session[:errors] << error_message
  else
    session[:errors] = [error_message]
  end
end

# rec param helpers
def format_rec(user_id = '')
  analyzed_rating = (params[:friend_rating].to_i + params[:self_rating].to_i) / 2
  params[:name] = params[:name].strip
  params[:description] = params[:description].strip
  rec_params = params.values + [analyzed_rating.to_s, user_id]
  rec_params.reject(&:empty?)
end

# Error detection methods
# Recommendation error checks
def valid_rec?
  check_rec_name
  check_rec_descr
  return true unless session[:error]
end

def check_rec_name
  return if params[:name].strip.size.between?(1, 50)

  params.delete(:name)
  register_error("Recommendation name must be between 1 and 50 characters")
end

def check_rec_descr
  return if params[:description].strip.size.between?(1, 140)

  params.delete(:description)
  register_error("Recommendation description must be between 1 and 140 characters")
end

# Friend name error check
def valid_friend?
  return true if params[:name].strip.size.between?(1, 25)

  params.delete[:name]
  register_error("Friend's name must be between 1 and 25 characters")
end

# View helper methods
# Sorts view based on criteria
def sorted_recs(recs, sort_type)
  case sort_type
  when 'completed'
    recs
  when 'media_type'
    recs.group_by {|h| h[:media_type]}.values.flatten
  when 'friend'
    recs.group_by {|h| h[:friend_id]}.values.flatten
  when 'small_score'
    recs.sort_by {|rec| rec[:analyzed_rating].to_i }
  when 'big_score'
    recs.sort_by {|rec| rec[:analyzed_rating].to_i }.reverse
  when 'movie'
    recs.select {|rec| rec[:media_type] == 'movie' }
  when 'game'
    recs.select {|rec| rec[:media_type] == 'game' }
  when 'book'
    recs.select {|rec| rec[:media_type] == 'book' }
  when 'tv'
    recs.select {|rec| rec[:media_type] == 'tv show' }
  end
end
