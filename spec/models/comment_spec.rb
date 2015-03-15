require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe ".create" do
    context "Do not create same comment" do
      before do
        Comment.delete_all

        @comment_data = {location: '/path1', username: 'foo', content: 'funny comment'}
        @another_comment_data = {location: '/path2', username: 'foo', content: 'funny comment'}
        Comment.create(@comment_data)
      end

      it "Do not create same comment" do
        expect { Comment.create(@comment_data) }.not_to change{ Comment.count }
      end

      it "Can create differnt comment" do
        expect { Comment.create(@another_comment_data) }.to change{ Comment.count }
      end
    end
  end
end
