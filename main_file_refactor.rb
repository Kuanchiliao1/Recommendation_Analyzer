# stores list of reccomendations and friends assigned to reccomendations
class Database
  def initialize
    @reccomendations = []
    @friends = []
  end

  def list_friends
    puts "I'm listing friends"
  end

  def list_reccomendations
  end

  def fetch_rec
  end

  def friend_recs
  end

  def delete_rec
  end
end

# seperate friend object so relationship scores can carry over between reccomendations
class Friend
  attr_reader :relationship_score

  def initialize(name, relationship_score)
    @name = name
    @relationship_score = relationship_score
  end

  def exists?
    !@name.nil?
  end
end

# reccomendation object where all scores are stored
class Recommendation
  attr_reader :score

  def initialize(title, media_type, self_score, friend_score, friend_object)
    @title = title
    @media_type = media_type
    @self_score = self_score
    @friend = friend_object
    @friend_score = friend_score
    @score = calculate_overall_score
  end

  def to_s
  end

  def calculate_overall_score
    if friend.exists?
      (self_score * friend.relationship_score * friend_score) / 3
    else
      self_score
    end
  end

  private

  attr_reader :self_score, :friend, :friend_score
end

# class for creating new recommendations
class RecommendationFetcher
  MEDIA_TYPES = "game movie show book".freeze
  RATING_RANGE = (1..10).freeze

  attr_accessor :rec_title, :media_type, :friend_name, :relationship_score, :friend_score, :self_score, :friend_object

  def initialize
    @rec_title = get_title
    reset
    @media_type = get_media_type
    reset
    @friend_name = get_friend_name
    reset
    @relationship_score = get_relationship_score unless friend_name.nil?
    reset
    @friend_score = get_friend_score if friend?
    reset
    @self_score = get_self_score
    reset
    display_info # need to add some way to display final overall score here
    # want to enter a line here that asks if everything is correct, then gives an option to change anything they want to change
    @friend_object = create_friend
    @rec_object = create_rec
    store_info if store?
    display_goodbye
  end

  def get_title
    loop do
      puts "What's the name of a book/movie/game/etc. that you've been meaning to get around to?"
      title = gets.chomp
      return title unless title.empty?

      puts "Please enter a non-empty name"
    end
  end

  def get_media_type
    loop do
      puts "What type of media is #{rec_title}? (Game, movie, show or book)"
      media = gets.chomp.downcase
      return media if MEDIA_TYPES.split.include?(media)

      puts "Please enter either game, movie, show, or book"
    end
  end

  def get_friend_name
    puts "Did a friend reccomend this to you?"
    choice = gets.chomp.downcase
    return nil if choice.start_with?('n')

    puts "Great!"
    loop do
      puts "What's your friends name?"
      name = gets.chomp.downcase
      return name unless name.empty?

      puts "Please enter a non empty name"
    end
  end

  def friend?
    !friend_name.nil?
  end

  def get_relationship_score
    loop do
      puts "What would you rate your friend on a scale from #{RATING_RANGE.first} to #{RATING_RANGE.last}? (as a person)"
      relationship_score = gets.chomp.to_i
      return relationship_score if RATING_RANGE.include?(relationship_score)

      puts "Please enter a number between #{RATING_RANGE.first} and #{RATING_RANGE.last}"
    end
  end

  def get_friend_score
    loop do
      puts "What did your friend rate #{rec_title} on a scale from #{RATING_RANGE.first} to #{RATING_RANGE.last}?"
      score = gets.chomp.to_i
      return score if RATING_RANGE.include?(score)

      puts "Please enter a number between #{RATING_RANGE.first} and #{RATING_RANGE.last}"
    end
  end

  def get_self_score
    loop do
      puts "What would you rate #{rec_title} on a scale from #{RATING_RANGE.first} to #{RATING_RANGE.last}? (based on your own opinions)"
      score = gets.chomp.to_i
      return score if RATING_RANGE.include?(score)

      puts "Please enter a number between #{RATING_RANGE.first} and #{RATING_RANGE.last}"
    end
  end

  def create_friend
    friend = Friend.new(friend_name, relationship_score)
  end

  def create_rec
    recommendation = Recommendation.new(rec_title, media_type, self_score, friend_score, friend_object)
  end

  def display_info
    puts "Ok here's what I got"
    sleep(1)
    puts "You've been reccomended the #{media_type} #{rec_title}."
    display_friend_info if friend?
    puts "You rate #{rec_title} a #{friend_score} out of #{RATING_RANGE.last}."
    # want to enter a line here that asks if everything is correct, then gives an option to change anything they want to change
  end

  def display_friend_info
    puts "This was reccomended to you by your friend #{friend_name}, who you rate #{relationship_score} out of #{RATING_RANGE.last}."
    puts "Your friend rates #{rec_title} a #{friend_score} out of #{RATING_RANGE.last}."
  end

  def store_info
    puts "Your recommendation has been saved"
    # add to database
    # the way this class is configured it currently doesn't have access to the database
  end

  def store?
    choice = nil
    loop do
      puts "Would you like save this information? (y/n)"
      choice = gets.chomp.downcase
      break if %w(y n).include?(choice)

      puts "Please enter y or n"
    end

    choice == 'y'
  end

  def display_goodbye
    puts "Thank you for using Reccomendation Analyzer"
  end

  def reset
    # system('clear')
  end
end

# main program
# PROGRAM_KEY needs updating to work. Basically want to create a key that takes a user input and returns a method name to be run if 
class Program
  PROGRAM_KEYS = ['add recommendation', 'list friends'].freeze

  def initialize
    @database = Database.new
  end

  def start
    opening_prompt
    loop do
      program_choice = choose_program
      run(program_choice)
      break if run_again?
    end
    goodbye_prompt
  end

  private

  attr_reader :database

  def opening_prompt
    puts "Welcome to Reccomendation Database"
  end

  def choose_program
    loop do
      puts "What program would you like to use today? (Available programs: #{PROGRAM_KEYS.join(', ')})"
      program = gets.chomp.downcase
      return program if PROGRAM_KEYS.include?(program)

      puts "Please input a valid program"
      puts "The available options are: #{PROGRAM_KEYS.join(', ')}"
    end
  end

  def run(program_choice)
    case program_choice
    when 'add recommendation'
      puts "recc"
      get_new_rec
    when 'list friends'
      database.list_friends
    end
  end

  def run_again?
    ans = nil
    loop do
      puts "Would you like to run another program? (y/n)"
      ans = gets.chomp.downcase
      return false if ans == 'y'
      return true if ans == 'n'

      puts "Please input either y or n"
    end
  end

  def get_new_rec 
    # setting to a variable in case code needs to be edited in a way that allows data to be used (such as storing new reccomendation to database)
    # may need to pass RecommendationFetcher a database here so it can save it's info to that database
    data = RecommendationFetcher.new
  end

  def goodbye_prompt
    puts "Goodbye, thank you for using Reccomendation Database"
  end
end

Program.new.start
