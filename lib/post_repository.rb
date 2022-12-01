require_relative 'post'

class PostRepository 
    def all
        posts = []
    
        # Send the SQL query and get the result set.
        sql = 'SELECT id, content, poster_id, post_time FROM posts;'
        result_set = DatabaseConnection.exec_params(sql, [])
        
        # The result set is an array of hashes.
        # Loop through it to create a model
        # object for each record hash.
        result_set.each do |record|
    
          # Create a new model object
          # with the record data.
          new_post = Post.new
          new_post.id = record['id'].to_i
          new_post.content = record['content']
          new_post.poster_id = record['poster_id']
          new_post.post_time = record['post_time']
    
          posts << new_post
        end
    
        return posts
      end


      def create(post)
        sql = 'INSERT INTO posts (content, poster_id, post_time) VALUES ($1, $2, $3);'
        result_set = DatabaseConnection.exec_params(sql, [post.content, post.poster_id, post.post_time])
  
        return nil
      end
end 