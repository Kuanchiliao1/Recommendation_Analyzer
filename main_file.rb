=begin
Recommendation Analyzer
Description: 
Do you get more recommendations than you possibly have time for? Have friends that recommend you a constant stream of content that you have no time to watch/read/listen even though you want to? Perhaps you even have a list somewhere sitting around and collecting dust. 

The Recommendation Analyzer will help you with getting to the top priority items by applying our proprietory algorithm to all your recs.

Now, instead of telling your friends that you'll "get to it" when they disappointedly ask you why you never follow their recs, you can confidently tell them that your life is at the mercy of an algorithm and there's nothing you can do. See how much better that sounds?

Here's how it goes:
1. Enter the title
2. Select a tag to indicate genre: 
3. From 1-10 rate you how much you 
4. How much do you THINK you'll enjoy this?
5

Input fields(* is optional):
- Title
- Type of media* - entering this allows you to filter your search results
- Genre* - entering this allows you to filter your search results
- Friend/source name
- Details*
Scales 1-10(all optional, but putting in more data gives better results)
- How much do you think you will actually enjoy this?
- Ask your friend to rate it themselves
- ...

Time multiplier
- Older stuff is worth less??

Add up the scores to get the final recommendation score



Additional features:
- Rate it again AFTER you finished it
- Graphs to see correlations between highest rec rating vs how much you enjoyed
- Place to put reviews
- Track who your top friends for recs are
- Add place for your friend to submit recs directly
=end
require 'io/console' 

class Friend
end

class Score
end

class Recommendation
  # @friend/source name
  # @score
  # @title
  attr_reader :title, :score

  def initialize
    @score
    @title
    @friend
    ask_info
  end

  def welcome
    system("clear")
    puts "Hi there!"
    sleep(1)
    puts "I'm the recommendation analyzer!"
    sleep(1)
    text = <<~TEXT 


    Do you get more recommendations than you possibly have time for? Have friends that recommend you a constant stream of content that you have no time to watch/read/listen even though you want to? Perhaps you even have a list somewhere sitting around and collecting dust. 

    The Recommendation Analyzer will help you with getting to the top priority items by applying our proprietory algorithm to all your recs.
    
    Now, instead of telling your friends that you'll "get to it" when they disappointedly ask you why you never follow their recs, you can confidently tell them that your life is at the mercy of an algorithm and there's nothing you can do. See how much better that sounds?
    TEXT
    puts text
    continue_story
  end

  def ask_friends
    system("clear")
    puts "First off, do you have any friends? (y/n)"
    choice = nil

    loop do
      choice = gets.chomp
      break if ["y", "n"].include?(choice)
      "Please enter a valid input!"
    end
    
    puts "Great!"
    sleep(1)
  end

  def ask_recommendation
    puts "What is a book/movie/game (it can be anything really) that a friend recommended to you but you haven't gotten around to?"
    puts "Please enter the name of the content here:"
    @title = gets.chomp
  end

  def ask_details
    puts "So it seems like your some recommended #{title} to you"
    
    puts "I'm going to ask you a short series of 4 questions to help calibrate our algorithm now"
    sleep(2)
    puts "(1/4)Who is the friend/source that recommended this to you?"
    friend_name = gets.chomp
    sleep(1)
    puts "Awesome. "
    puts "(2/4) On a scale of 1-10, how much do YOU want to read #{title}?"
    self_rating = gets.chomp
    sleep(1)
    puts "(3/4) On a scale of 1-10, what does your friend rate #{title}?"
    friend_rating = gets.chomp
    sleep(1)
    puts "(4/4) On a scale of 1-10, what do you rate your friend #{friend_name} overall?"
    actual_friend_rating = gets.chomp
    sleep(1)
    puts "Perfect!"
    continue_story
    system("clear")
    puts "To conclude... \nYou rate #{friend_name} a #{actual_friend_rating} out of 10 as a person\nYou rate #{title} a #{friend_rating} out of 10\n And you rate #{title} a #{actual_friend_rating} out of 10"
  end

  def display_score
    "Your recommendation score for this item is #{score}"
  end

  def ask_info
    welcome
    ask_friends
    ask_recommendation
    ask_details
    display_score
  end

  def continue_story                                                                                                               
    print "\n===>press any key to continue\r"                                                                                                    
    STDIN.getch                                                                                                              
    print "            \r" # extra space to overwrite in case next sentence is short                                                                                                              
  end
end

Recommendation.new