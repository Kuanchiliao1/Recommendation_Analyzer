require "pg"

class AnalyzerDatabase
  def initialize(logger)
    @db = PG.connect(dbname: "recommendations")
    @logger = logger
  end

  # Execute Sql queries safely
  def query(statement, *params)
    @logger.info "#{statement}: #{params}"
    @db.exec_params(statement, params)
  end

  # Create recommendation + generate analyzed score
  #   Consider hash/array as paramater rather than seperate params
  #   Should be okay if info is sanitized before passed to sql (which it should be)
  def create_rec(name, media_type, description, friend_id, friend_rating, self_rating)
    analyzed_rating = (friend_rating + self_rating) / 2
    sql = <<~SQL
      INSERT INTO recommendations
            (name, media_type, description, friend_id,
            friend_rating, self_rating, analyzed_rating)
            VALUES ($1, $2, $3, $4, $5, $6, $7)
    SQL

    query(sql, name, media_type, description, friend_id,
          friend_rating, self_rating, analyzed_rating)
  end

  # Create friend
  def create_friend(name, trust_rating)
    sql = "INSERT INTO friends (name, trust_rating) VALUES ($1, $2)"
    query(sql, name, trust_rating)
  end

  # Return recommendations + info
  def all_recs
    sql = "SELECT * FROM recommendations"
    result = query(sql)
    format_result(result)
  end

  # Return all completed recommendations + info
  def completed_recs
    sql = "SELECT * FROM recommendations WHERE completed IS TRUE"
    result = query(sql)
    format_result(result)
  end

  # Return all recommendations with friends info
  def recs_with_friends
    sql = "SELECT r.*, f.name AS fname FROM recommendations AS r LEFT JOIN friends AS f ON r.friend_id = f.id"
    result = query(sql)
    format_result(result)
  end

  # Return single recommendation
  def find_rec(id)
    sql = "SELECT * FROM recommendations WHERE id = $1"
    result = query(sql, id)
    format_result(result, single = true)
  end

  # Return list of existing friend names
  def all_friends
    sql = "SELECT * FROM friends"
    result = query(sql)
    format_result(result)
  end

  # Return list of existing friend names
  def all_friends_names
    sql = "SELECT name FROM friends"
    result = query(sql)
    format_result(result)
  end

  # Return friend
  def find_friend(id)
    sql = "SELECT * FROM friends WHERE id = $1"
    result = query(sql, id)
    format_result(result, single = true)
  end

  # Update info for recommendation
  def update_rec(id, name, media_type, description, friend_id, friend_rating, self_rating, completed_rating)
    sql = <<~SQL
      UPDATE recommendations
      SET name = $2, media_type = $3, description = $4, friend_id = $5,
      friend_rating = $6, self_rating = $7, completed_rating = $8)
      WHERE id = $1
    SQL

    query(sql, id, name, media_type, description, friend_id,
          friend_rating, self_rating, completed_rating)
  end

  # Update recommendation to be completed + add completion date
  def complete_rec(id, completed_rating)
    sql = "UPDATE reccomendations SET completed = true, completed_rating = $2, completed_date = NOW() WHERE id = $1"
    query(sql, id, completed_rating)
  end

  # Update recommendation to be incomplete

  # Update friend info
  def update_friend(id, name, trust_rating)
    sql = "UPDATE friends SET name = $2, trust_rating = $3 WHERE id = $1"
    query(sql, id, name, trust_rating)
  end

  # Delete recommendation
  def delete_rec(id)
    sql = "DELETE FROM recommendations WHERE id = $1"
    query(sql, id)
  end

  # Delete friend + their recommendations
  def delete_friend(id)
    sql = "DELETE FROM recommendations WHERE friend_id = $1"
    query(sql, id)

    sql2 = "DELETE FROM friends WHERE id = $1"
    query(sql2, id)
  end

  # Return result object formatted as an array of hashes (or single hash if single = true)
  def format_result(result, single = false)
    formatted = result.map do |tuple|
      result.fields.each_with_object({}) do |field, hash|
        hash[field.to_sym] = tuple[field]
      end
    end

    return formatted unless single == true

    formatted[0]
  end
end
