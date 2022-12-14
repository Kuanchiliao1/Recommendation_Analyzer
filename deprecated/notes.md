
def press_to_continue
  print "\n===>press any key to continue\r"
  STDIN.getch
  print "            \r" # extra space to overwrite in case next sentence is short
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
  press_to_continue
end


=begin
---------------
Stackoverflow answers on how to do OOD
The steps that I use for initial design (getting to a class diagram), are:

Requirements gathering. Talk to the client and factor out the use cases to define what functionality the software should have.


Compose a narrative of the individual use cases.

Go through the narrative and highlight nouns (person, place, thing), as candidate classes and verbs (actions), as methods / behaviors.

Discard duplicate nouns and factor out common functionality.

Create a class diagram. If you're a Java developer, NetBeans 6.7 from Sun has a UML module that allows for diagramming as well as round-trip engineering and it's FREE. Eclipse (an open source Java IDE), also has a modeling framework, but I have no experience with it. You may also want to try out ArgoUML, an open source tool.

online.visual-paradigm.com/app/diagrams
---------------
Apply OOD principles to organize your classes (factor out common functionality, build hierarchies, etc.)

Make absolutely sure you know what your program is all about before you start. What is your program? What will it not do? What problem is it trying to solve?

# My program is aiming to gather the recommendations from users, and help them decide what content they should consume last. It will store the stuff recommended to them for future use. Stores info about their friends/source. 
  # It will NOT 
  # It's trying to solve the problem of having too many recommendations to chose from

Your first set of use cases shouldn't be a laundry list of everything the program will eventually do. Start with the smallest set of use cases you can come up with that still captures the essence of what your program is for. For this web site, for example, the core use cases might be log in, ask a question, answer a question, and view questions and answers. Nothing about reputation, voting, or the community wiki, just the raw essence of what you're shooting for.
# The user enters a recommendation and answer some quesitons
  # Then, this data is stored and the user can compare all of their recommendations. The app will display the top scoring ones to them first.
# 

As you come up with potential classes, don't think of them only in terms of what noun they represent, but what responsibilities they have. I've found this to be the biggest aid in figuring out how classes relate to each other during program execution. It's easy to come up with relationships like "a dog is an animal" or "a puppy has one mother." It's usually harder to figure out relationships describing run-time interactions between objects. You're program's algorithms are at least as important as your objects, and they're much easier to design if you've spelled out what each class's job is.

Once you've got that minimal set of use cases and objects, start coding. Get something that actually runs as soon as possible, even though it doesn't do much and probably looks like crap. It's a starting point, and will force you to answer questions you might gloss over on paper.

Now go back and pick more use cases, write up how they'll work, modify your class model, and write more code. Just like your first cut, take on as little at a time as you can while still adding something meaningful. Rinse and repeat.
---------------

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


=begin
Recommendation
  - constructor
    - 

User
  - constructor
    - @recs = []
    - @name = get_name
    - @friends = []
  - get_name
  - new_rec
    - Create Rec obj

Program
  - constructor
    - @users = []s
    - new_user
  - new_user
    - Create User obj 
=end