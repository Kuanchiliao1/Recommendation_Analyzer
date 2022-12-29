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

get "/" do
  erb @database.hello_test
end

# Home (Recommendations) Page
#  Perhaps first part of route could be logged in users name
#  So the link to recommendations page for logged in user would be: "http://localhost:4567/user"

# Create Recommendation Page

# Filter Recs button

# View Rec Page

# Edit Rec Page

# Delete Rec Button

# Friends Page

# New Friend Page

# Delete friend button

# Account Page

# Support Page
