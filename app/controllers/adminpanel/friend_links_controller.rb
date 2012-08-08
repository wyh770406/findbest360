# coding: UTF-8
class Adminpanel::FriendLinksController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"
  def index

    @friend_links = FriendLink.all.desc("created_at").page(params[:page]).per(300)

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end

  def show

    @friend_link = FriendLink.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json
    end
  end

  def new

    @friend_link = FriendLink.new

    respond_to do |format|
      format.html # new.html.erb
      format.json
    end
  end

  def edit

    @friend_link = FriendLink.find(params[:id])
  end

  def create

    @friend_link = FriendLink.new(params[:friend_link])

    respond_to do |format|
      if @friend_link.save

        format.html { redirect_to(adminpanel_friend_links_path, :notice => 'FriendLink 创建成功。') }
        format.json
      else
        format.html { render :action => "new" }
        format.json
      end
    end
  end

  def update

    @friend_link = FriendLink.find(params[:id])

    respond_to do |format|
      if @friend_link.update_attributes(params[:friend_link])
        format.html { redirect_to(adminpanel_friend_links_path, :notice => 'FriendLink 更新成功。') }
        format.json
      else
        format.html { render :action => "edit" }
        format.json
      end
    end
  end


  def destroy

    @friend_link = FriendLink.find(params[:id])
    @friend_link.destroy

    respond_to do |format|
      format.html { redirect_to(adminpanel_friend_links_path,:notice => "删除成功。") }
      format.json
    end
  end
end
