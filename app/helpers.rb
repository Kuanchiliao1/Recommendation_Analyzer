def generate_rec_params
  analyzed_rating = (params[:friend_rating].to_i + params[:self_rating].to_i) / 2
  rec_params = params.values << analyzed_rating
end
