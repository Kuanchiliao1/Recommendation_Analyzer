def generate_rec_params
  analyzed_rating = (params[:friend_rating].to_i + params[:self_rating].to_i) / 2
  [@user_id, analyzed_rating] + params.values
end

def generate_updated_rec_params
  analyzed_rating = (params[:friend_rating].to_i + params[:self_rating].to_i) / 2
  params.values.reject(&:empty?) << analyzed_rating
end

def generate_completed_rec_params
  analyzed_rating = (params[:friend_rating].to_i + params[:self_rating].to_i) / 2
  params.values << analyzed_rating
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
    recs.select {|rec| rec[:media_type] == 'movie'}
  when 'game'
    recs.select {|rec| rec[:media_type] == 'game'}
  when 'book'
    recs.select {|rec| rec[:media_type] == 'book'}
  when 'tv'
    recs.select {|rec| rec[:media_type] == 'tv show'}
  end
end
