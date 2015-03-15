require 'rails_helper'

describe "Comments API" do
  describe "GET /comments" do
    before do
      Comment.delete_all
      Comment.create(location: '/path1', username: 'foo', content: 'funny comment', approved: true)
      Comment.create(location: '/path1', username: 'bar', content: 'much funny comment', approved: true)
      Comment.create(location: '/path1', username: 'hoge', content: 'unapproved comment', approved: false)
      Comment.create(location: '/path2', username: 'someone', content: 'comment for another path', approved: true)
    end

    context "when requested with valid client_key" do
      before do
        get "/comments", {location: '/path1', client_key: Setting::client_key}, { "HTTP_ACCEPT" => "application/json" }
        @comments = JSON.parse(response.body)
      end

      it "returns http status 200" do
        expect(response.status).to eq 200
      end

      it "returns all approved comments for a location" do
        expect(@comments.count).to eq 2
      end

      it "contains collect usernames" do
        usernames = @comments.map { |c| c["username"] }
        expect(usernames).to match_array(["foo", "bar"])
      end
    end

    context "when requested comments for another path" do
      before do
        get "/comments", {location: '/path2', client_key: Setting::client_key}, { "HTTP_ACCEPT" => "application/json" }
        @comments = JSON.parse(response.body)
      end

      it "returns http status 200" do
        expect(response.status).to eq 200
      end

      it "returns all approved comments for a location" do
        expect(@comments.count).to eq 1
      end

      it "contains collect usernames" do
        usernames = @comments.map { |c| c["username"] }
        expect(usernames).to match_array(["someone"])
      end
    end

    context "when requested invalid client_key" do
      before do
        get "/comments", {location: '/path1', client_key: "invalidkey"}, { "HTTP_ACCEPT" => "application/json" }
      end

      it "returns http status 404" do
        expect(response.status).to eq 404
      end
    end

    context "when requested without client_key" do
      before do
        get "/comments", {location: '/path1'}, { "HTTP_ACCEPT" => "application/json" }
      end

      it "returns http status 404" do
        expect(response.status).to eq 404
      end
    end

  end

  describe "POST /comments" do
    before do
      Comment.delete_all
      Comment.create(location: '/path1', username: 'bar', content: 'existed comment', approved: true)

      @comment_params = {
        location: '/path1',
        username: 'foo',
        content: 'oh',
        mail: 'foo@example.com',
        link: 'www.example.com'
      }
    end

    context "when Setting::default_approved is true" do
      before do
        post "/comments", {comment: @comment_params, client_key: Setting::client_key}, { "HTTP_ACCEPT" => "application/json" }
        @result = JSON.parse(response.body)
      end

      it "returns http status 200" do
        expect(response.status).to eq 200
      end

      it "created new comment" do
        expect(Comment.count).to eq 2
      end

      it "returns username of new comment" do
        expect(@result["username"]).to eq "foo"
      end

      it "returns content of new comment" do
        expect(@result["content"]).to eq "oh"
      end
    end

    context "when Setting::default_approved is false" do
      before do
        Setting.first.update_attributes!(default_approved: false)
        post "/comments", {comment: @comment_params, client_key: Setting::client_key}, { "HTTP_ACCEPT" => "application/json" }
        @result = JSON.parse(response.body)
      end

      after do
        Setting.first.update_attributes!(default_approved: true)
      end

      it "returns http status 200" do
        expect(response.status).to eq 200
      end

      it "created new comment" do
        expect(Comment.count).to eq 2
      end

      it "returns 'admin' for username of new comment" do
        expect(@result["username"]).to eq "admin"
      end

      it "returns waiting message for content of new comment" do
        expect(@result["content"]).to eq "This comment is waiting to be approved."
      end
    end

    context "when commented_at is specified(for import)" do
      before do
        @comment_params[:commented_at] = '2015-01-02 12:34:56'
        post "/comments", {comment: @comment_params, client_key: Setting::client_key}, { "HTTP_ACCEPT" => "application/json" }
        @result = JSON.parse(response.body)
      end

      it "returns http status 200" do
        expect(response.status).to eq 200
      end

      it "created new comment" do
        expect(Comment.count).to eq 2
      end

      it "returns '2015-01-02 12:34:56' for commented_at of new comment" do
        expect(@result["commented_at"]).to eq '2015-01-02T12:34:56.000+00:00'
      end
    end

    context "when username is blank" do
      before do
        @comment_params[:username] = ''
        post "/comments", {comment: @comment_params, client_key: Setting::client_key}, { "HTTP_ACCEPT" => "application/json" }
        @result = JSON.parse(response.body)
      end

      it "returns http status 200" do
        expect(response.status).to eq 200
      end

      it "not created new comment" do
        expect(Comment.count).to eq 1
      end

      it "returns 'Error' for username of new comment" do
        expect(@result["username"]).to eq "Error"
      end

      it "returns error message for content of new comment" do
        expect(@result["content"]).to eq ["Username can't be blank"]
      end
    end

    context "when content is blank" do
      before do
        @comment_params[:content] = ''
        post "/comments", {comment: @comment_params, client_key: Setting::client_key}, { "HTTP_ACCEPT" => "application/json" }
        @result = JSON.parse(response.body)
      end

      it "returns http status 200" do
        expect(response.status).to eq 200
      end

      it "not created new comment" do
        expect(Comment.count).to eq 1
      end

      it "returns 'Error' for username of new comment" do
        expect(@result["username"]).to eq "Error"
      end

      it "returns error message for content of new comment" do
        expect(@result["content"]).to eq ["Content can't be blank"]
      end
    end

    context "when requested invalid client_key" do
      before do
        post "/comments", {comment: @comment_params, client_key: 'invalidkey'}, { "HTTP_ACCEPT" => "application/json" }
      end

      it "returns http status 404" do
        expect(response.status).to eq 404
      end
    end

    context "when requested without client_key" do
      before do
        post "/comments", {comment: @comment_params}, { "HTTP_ACCEPT" => "application/json" }
      end

      it "returns http status 404" do
        expect(response.status).to eq 404
      end
    end
  end
end