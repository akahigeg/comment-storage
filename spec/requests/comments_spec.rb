require 'rails_helper'

describe "Comments API" do
  describe "GET /comments" do
    before do
      Comment.delete_all
      Comment.create(location: '/path1', username: 'foo', content: 'funny comment')
      Comment.create(location: '/path1', username: 'bar', content: 'much funny comment')
      Comment.create(location: '/path2', username: 'someone', content: 'comment for another path')

      get "/comments", {location: '/path1'}, { "HTTP_ACCEPT" => "application/json" }
      @comments = JSON.parse(response.body)
    end

    it "returns all the comments for a location" do
      expect(response.status).to eq 200
    end

    it "returns 2 comments" do
      expect(@comments.count).to eq 2
    end

    it "contains collect usernames" do
      usernames = @comments.map { |c| c["username"] }
      expect(usernames).to match_array(["foo", "bar"])
    end
  end
end