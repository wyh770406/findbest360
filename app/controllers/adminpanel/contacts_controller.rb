# coding: UTF-8
class Adminpanel::ContactsController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"
  def index

    @contacts = Contact.all.desc("created_at").page(params[:page]).per(300)

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end

  def show

    @contact = Contact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json
    end
  end

  def new

    @contact = Contact.new

    respond_to do |format|
      format.html # new.html.erb
      format.json
    end
  end

  def edit

    @contact = Contact.find(params[:id])
  end

  def create

    @contact = Contact.new(params[:contact])

    respond_to do |format|
      if @contact.save

        format.html { redirect_to(adminpanel_contacts_path, :notice => 'Contact 创建成功。') }
        format.json
      else
        format.html { render :action => "new" }
        format.json
      end
    end
  end

  def update

    @contact = Contact.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.html { redirect_to(adminpanel_contacts_path, :notice => 'Contact 更新成功。') }
        format.json
      else
        format.html { render :action => "edit" }
        format.json
      end
    end
  end


  def destroy

    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to(adminpanel_contacts_path,:notice => "删除成功。") }
      format.json
    end
  end
end
