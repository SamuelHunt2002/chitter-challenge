require 'post'
require 'post_repository'

def reset_albums_table
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'Chitter' })
  connection.exec(seed_sql)
end

describe PostRepository do
  before(:each) do 
    reset_albums_table
  end

  it "Retrives all posts" do
    post_repo = PostRepository.new()
    all_posts = post_repo.all
    expect(all_posts.length).to eq 3 
    expect(all_posts.first.id).to eq 1
    expect(all_posts.first.content).to eq "This should work"
  end

  it "Creates" do
    post_repo = PostRepository.new
    new_post = Post.new()
    time = DateTime.parse("18-Feb-2016 09:01:04")
    new_post.content = "Added post"
    new_post.poster_id = 2
    new_post.post_time = time
    post_repo.create(new_post)
    all_posts = post_repo.all
    expect(all_posts.length).to eq 4
  end




end 