require "user"
require "user_repository"

def reset_albums_table
  seed_sql = File.read("spec/seeds.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "Chitter" })
  connection.exec(seed_sql)
end

describe UserRepository do
  before(:each) do
    reset_albums_table
  end

  it "Gets all users" do
    user_repo = UserRepository.new()
    all_users = user_repo.all
    expect(all_users.length).to eq 4
    expect(all_users.first.id).to eq 1
    expect(all_users.first.first_name).to eq "Sam"
  end

  it "Creates a user" do
    user_repo = UserRepository.new()
    all_users = user_repo.all
    expect(all_users.length).to eq 4
    new_user = User.new()
    new_user.username = "New_User"
    new_user.pass = "doajfepoafj"
    new_user.first_name = "Bob"
    new_user.last_name = "Marley"
    user_repo.create(new_user)
    all_users = user_repo.all
    expect(all_users.length).to eq 5
  end

  it "Finds by username returns nil if incorrect username" do
    user_repo = UserRepository.new()
    expect(user_repo.find_by_username("adafda")).to eq nil
  end

  it "Finds by username returns a user if correct username" do
    user_repo = UserRepository.new()
    expect(user_repo.find_by_username("Sam123")).to_not eq nil
  end

  it "Log in returns true if I have the right pass" do
    user_repo = UserRepository.new()
    expect(user_repo.sign_in("Sam123","password")).to eq true 
  end
end
