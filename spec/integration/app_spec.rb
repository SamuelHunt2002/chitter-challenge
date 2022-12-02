require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }


  it "Returns a 200 for login" do
  response = get("/login")
  expect(response.status).to eq 200
  expect(response.body).to include("Log in")
  end 

  it "Logs in successfully" do
response = post("/login", username: "Sam123", pass: "password")
expect(response.status).to eq 200

  end

  it "Posts" do
    response = post("/post", content: 'Why isnt this working', poster_id: '2', post_time:'2022-11-01 ')
    expect(response.status).to eq 200
  end
end 