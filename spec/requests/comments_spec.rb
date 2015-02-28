require 'rails_helper'

describe "Comments API" do
  describe "GET /comments" do
    before do
      Comment.delete_all
      Comment.create(location: '/path1', username: 'foo', content: 'funny comment', accepted: true)
      Comment.create(location: '/path1', username: 'bar', content: 'much funny comment', accepted: true)
      Comment.create(location: '/path1', username: 'hoge', content: 'unaccepted comment', accepted: false)
      Comment.create(location: '/path2', username: 'someone', content: 'comment for another path', accepted: true)
    end

    context "requested with valid client_key" do
      before do
        get "/comments", {location: '/path1', client_key: Setting::client_key}, { "HTTP_ACCEPT" => "application/json" }
        @comments = JSON.parse(response.body)
      end

      it "returns http status 200" do
        expect(response.status).to eq 200
      end

      it "returns all accepted comments for a location" do
        expect(@comments.count).to eq 2
      end

      it "contains collect usernames" do
        usernames = @comments.map { |c| c["username"] }
        expect(usernames).to match_array(["foo", "bar"])
      end
    end

    context "requested comments for another path" do
      before do
        get "/comments", {location: '/path2', client_key: Setting::client_key}, { "HTTP_ACCEPT" => "application/json" }
        @comments = JSON.parse(response.body)
      end

      it "returns http status 200" do
        expect(response.status).to eq 200
      end

      it "returns all accepted comments for a location" do
        expect(@comments.count).to eq 1
      end

      it "contains collect usernames" do
        usernames = @comments.map { |c| c["username"] }
        expect(usernames).to match_array(["someone"])
      end
    end

    context "requested invalid client_key" do
      before do
        get "/comments", {location: '/path1', client_key: "invalidkey"}, { "HTTP_ACCEPT" => "application/json" }
      end

      it "returns http status 404" do
        expect(response.status).to eq 404
      end
    end

    context "requested without client_key" do
      before do
        get "/comments", {location: '/path1'}, { "HTTP_ACCEPT" => "application/json" }
      end

      it "returns http status 404" do
        expect(response.status).to eq 404
      end
    end

  end
end