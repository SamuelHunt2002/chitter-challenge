require 'bcrypt'
require_relative 'user'
class UserRepository
  include BCrypt
  def all
    users = []

    # Send the SQL query and get the result set.
    sql = "SELECT id, username, pass, first_name, last_name FROM users;"
    result_set = DatabaseConnection.exec_params(sql, [])

    # The result set is an array of hashes.
    # Loop through it to create a model
    # object for each record hash.
    result_set.each do |record|

      # Create a new model object
      # with the record data.
      new_user = User.new
      new_user.id = record["id"].to_i
      new_user.username = record["username"]
      new_user.pass = record["pass"]
      new_user.first_name = record["first_name"]
      new_user.last_name = record["last_name"]

      users << new_user
    end

    return users
  end

  def create(user)
    sql = "INSERT INTO users (username, pass, first_name, last_name) VALUES ($1, $2, $3, $4);"
    encrypted_password = BCrypt::Password.create(user.pass)
    result_set = DatabaseConnection.exec_params(sql, [user.username, encrypted_password, user.first_name, user.last_name])

    return nil
  end

  def sign_in(username, submitted_password)
    user = find_by_username(username)

    return nil if user.nil?
    # Compare the submitted password with the encrypted one saved in the database
    if user.pass == BCrypt::Password.create(submitted_password) || user.pass = submitted_password
      # login success
      return true 
    else
      # wrong password
      return false
    end
  end

  def find_by_username(username)
    # ...
    sql = "SELECT * FROM users WHERE username = $1"
    begin
      result_set = DatabaseConnection.exec_params(sql, [username])

      returned_user = User.new()
      returned_user.id = result_set[0]["id"]
      returned_user.username = result_set[0]["username"]
      returned_user.pass = result_set[0]["pass"]
      returned_user.first_name = result_set[0]["first_name"]
      returned_user.last_name = result_set[0]["last_name"]
      return returned_user
    rescue IndexError
      return nil
    end
  end
end
