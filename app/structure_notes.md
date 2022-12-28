Required Elements

  Reccomendation
    Id (primary key)
    Name (50 chars)
    Media Type (Must be either movie, tv show, book, game)
    Description (140 chars, defaults empty)
    Friend *id? (foreign key referencing friend)
    Friend rating (1-10)
    Self Prediction (1-10)
    Date Added (automatic)
    Reccomended score *maybe dont include, generate on layout (generated)
    Completion status (boolean, default false)
    Completed rating (1-10, optional)
    Completion date (generated, optional)

  Friend
    Friend id (primary key)
    Friend name (20 chars)
    Friend rating, how much you trust friend (1-10)

