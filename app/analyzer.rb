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
end

# Test Route
get "/test" do
  @recs = @database.all_recs
  @recs_and_friends = @database.recs_with_friends
  @rec = @database.find_rec(1)
  @friends = @database.all_friends
  @friends_names = @database.all_friends_names
  @friend = @database.find_friend(1)
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
  @recommendations = @database.recs_with_friends
  erb :recommendations, layout: :layout
end

# Create Recommendation Page
get "/recommendations/new" do
  erb :new_rec, layout: :layout
end

# Filter Recs button

# View Rec Page
get "/recommendations/:rec_id" do
  @rec = @database.find_rec(params[:rec_id])
  erb :rec, layout: :layout
end

# Edit Rec Page
get "/recommendations/:rec_id/edit" do
  @rec = @database.find_rec(params[:rec_id])
  erb :edit_rec, layout: :layout
end

# Delete Rec Button
post '/recommendations/:rec_id/delete' do
  @database.delete_rec(params[:rec_id])
  # register success message
  redirect "/home"
end

# Friends Page
get "/friends" do
  @friends = @database.all_friends
  erb :friends, layout: :layout
end

# New Friend Page
get "/friends/new" do
  erb :new_friend, layout: :layout
end

# Edit Friend Info Page
get "/friends/:friend_id/edit" do
  @friend = @database.find_friend(params[:friend_id])
  erb :edit_friend, layout: :layout
end

# Delete Friend Button
post "/friends/:friend_id/delete" do
  @database.delete_friend(params[:friend_id])
  redirect "/home"
end

# Account Page
get "/account" do
  erb :account, layout: :layout
end

# Support Page
get "/support" do
  erb :support, layout: :layout
end
