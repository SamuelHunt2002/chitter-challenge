class UserRepository

    def all
        users = []
    
        # Send the SQL query and get the result set.
        sql = 'SELECT id, username, pass, first_name, last_name FROM users;'
        result_set = DatabaseConnection.exec_params(sql, [])
        
        # The result set is an array of hashes.
        # Loop through it to create a model
        # object for each record hash.
        result_set.each do |record|
    
          # Create a new model object
          # with the record data.
          new_user = User.new
          new_user.id = record['id'].to_i
          new_user.username = record['username']
          new_user.pass = record['pass']
          new_user.first_name = record['first_name']
          new_user.last_name = record['last_name']

    
          users << new_user
        end
    
        return users
      end


    def create(user)
    sql = 'INSERT INTO users (username, pass, first_name, last_name) VALUES ($1, $2, $3, $4);'
    result_set = DatabaseConnection.exec_params(sql, [user.username, user.pass, user.first_name, user.last_name])

    return nil
  end
end 