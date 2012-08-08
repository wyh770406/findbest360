class FriendLinksController < ApplicationController
  def index
    @friend_link = FriendLink.all.first
  end

end