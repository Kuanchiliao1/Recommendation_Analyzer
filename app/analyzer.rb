require "sinatra"
require "sinatra/content_for"
require "tilt/erubis"

require_relative "database.rb"
require_relative "helpers.rb"

# Establish browser sessions and escape any html injection
configure do
  enable :sessions
  set :session_secret, "04c032bd7c1c48804f6482d29e02e582847579c704dc9ff61ee467d9bc7cacca"
  set :erb, :escape_html => true
end

# Initialize database connection
before do
  @database = AnalyzerDatabase.new(logger)
  @user_id = 1
end

# Test Route
get "/test" do
  @recs = @database.all_recs(@user_id)
  @recs_and_friends = @database.recs_with_friends(@user_id)
  @rec = @database.find_rec(@user_id, 1)
  @friends = @database.all_friends(@user_id)
  @friends_names = @database.all_friends_names(@user_id)
  @friend = @database.find_friend(1)
  @query = params[:sort]
  @group = @recs.group_by {|h| h[:media_type]}.values.flatten
  erb :test, layout: :layout
end

# Redirect to homepage
get "/" do
  redirect "/home"
end

# Home (Recommendations) Page
#  Perhaps first part of route could be logged in users name
#  So the link to recommendations page for logged in user would be: "http://localhost:4567/user"
get "/home" do
  @recs = @database.recs_with_friends(@user_id)
  @sort = params[:sort] || 'completed'
  erb :recommendations, layout: :layout
end

# Create Recommendation Page
get "/recommendations/new" do
  @friends = @database.all_friends(@user_id)
  erb :new_rec, layout: :layout
end

# Add New Recommendation
post "/recommendations/new" do
  @database.create_rec(generate_rec_params)
  # Add flash message
  redirect "/home"
end

# View Rec Page
get "/recommendations/:rec_id" do
  @rec = @database.find_rec(params[:rec_id])
  erb :rec, layout: :layout
end

# Edit Rec Page
get "/recommendations/:rec_id/edit" do
  @friends = @database.all_friends(@user_id)
  @rec = @database.find_rec(params[:rec_id])
  erb :edit_rec, layout: :layout
end

post "/recommendations/:rec_id/edit" do
  if params[:completed_status] == "completed"
    @database.complete_rec(generate_completed_rec_params)
  else
    @database.update_rec(generate_updated_rec_params)
  end
  redirect "/home"
end

# Delete Rec Button
post '/recommendations/:rec_id/delete' do
  @database.delete_rec(params[:rec_id])
  # register success message
  redirect "/home"
end

# Friends Page
get "/friends" do
  @friends = @database.all_friends(@user_id)
  erb :friends, layout: :layout
end

# New Friend Page
get "/friends/new" do
  erb :new_friend, layout: :layout
end

# Add New Friend
post "/friends/new" do
  @database.create_friend(@user_id, params[:friend_name], params[:trust_rating])
  # confirmation flash message
  redirect "/friends"
end

# Edit Friend Info Page
get "/friends/:friend_id/edit" do
  @friend = @database.find_friend(params[:friend_id])
  erb :edit_friend, layout: :layout
end

# Delete Friend Button
post "/friends/:friend_id/delete" do
  @database.delete_friend(params[:friend_id])
  redirect "/friends"
end

# Account Page
get "/account" do
  erb :account, layout: :layout
end

# Support Page
get "/support" do
  erb :support, layout: :layout
end
