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

  # Create recommendation
  def create_rec(rec_params)
    sql = <<~SQL
      INSERT INTO recommendations
                  (name, media_type, description, friend_id,
                  friend_rating, self_rating, analyzed_rating, user_id)
           VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
    SQL

    query(sql, *rec_params)
  end

  # Create friend
  #   Considering changing to array like create_rec
  def create_friend(user_id, name, trust_rating)
    sql = "INSERT INTO friends (user_id, name, trust_rating) VALUES ($1, $2, $3)"
    query(sql, user_id, name, trust_rating)
  end

  # DEPRECATED Return recommendations, sorted by completion status
  def all_recs(user_id)
    sql = "SELECT * FROM recommendations WHERE user_id = $1 ORDER BY completed_status"
    result = query(sql, user_id)
    format_result(result)
  end

  # Return all recommendations with friends info
  def recs_with_friends(user_id)
    sql = <<~SQL
      SELECT r.*, f.name AS fname FROM recommendations AS r
      LEFT JOIN friends AS f ON r.friend_id = f.id
      WHERE r.user_id = $1
      ORDER BY completed_status
    SQL

    result = query(sql, user_id)
    format_result(result)
  end

  # Return single recommendation
  def find_rec(id)
    sql = "SELECT * FROM recommendations WHERE id = $1"
    result = query(sql, id)
    format_result(result, single = true)
  end

  # Return list of existing friend names
  def all_friends(user_id)
    sql = "SELECT * FROM friends WHERE user_id = $1"
    result = query(sql, user_id)
    format_result(result)
  end

  # Return list of existing friend names
  def all_friends_names(user_id)
    sql = "SELECT name FROM friends WHERE user_id = $1"
    result = query(sql, user_id)
    format_result(result)
  end

  # Return friend
  def find_friend(id)
    sql = "SELECT * FROM friends WHERE id = $1"
    result = query(sql, id)
    format_result(result, single = true)
  end

  # Update info for recommendation
  def update_rec(rec_params)
    sql = <<~SQL
      UPDATE recommendations
      SET name = $1, media_type = $2, description = $3,
      friend_id = $4, friend_rating = $5, self_rating = $6,
      completed_status = $7, analyzed_rating = $9
      WHERE id = $8
    SQL

    query(sql, *rec_params)
  end

  # Update info for recommendation that is completed
  def complete_rec(rec_params)
    sql = <<~SQL
      UPDATE recommendations
      SET name = $1, media_type = $2, description = $3, friend_id = $4,
      friend_rating = $5, self_rating = $6, completed_status = $7,
      completed_rating = $8, completed_date = NOW(), analyzed_rating = $10
      WHERE id = $9
    SQL

    query(sql, *rec_params)
  end

  # Update friend info
  def update_friend(id, name, trust_rating)
    sql = "UPDATE friends SET name = $2, trust_rating = $3 WHERE id = $1"
    query(sql, id, name, trust_rating)
  end

  # Delete recommendation
  def delete_rec (id)
    sql = "DELETE FROM recommendations WHERE id = $1"
    query(sql, id)
  end

  # Delete friend + their recommendations
  def delete_friend (id)
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
