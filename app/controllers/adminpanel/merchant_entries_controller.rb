# coding: UTF-8
class Adminpanel::MerchantEntriesController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"
  def index

    @merchant_entries = MerchantEntry.all.desc("created_at").page(params[:page]).per(300)

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end

  def show

    @merchant_entry = MerchantEntry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json
    end
  end

  def new

    @merchant_entry = MerchantEntry.new

    respond_to do |format|
      format.html # new.html.erb
      format.json
    end
  end

  def edit

    @merchant_entry = MerchantEntry.find(params[:id])
  end

  def create

    @merchant_entry = MerchantEntry.new(params[:merchant_entry])

    respond_to do |format|
      if @merchant_entry.save

        format.html { redirect_to(adminpanel_merchant_entries_path, :notice => 'MerchantEntry 创建成功。') }
        format.json
      else
        format.html { render :action => "new" }
        format.json
      end
    end
  end

  def update

    @merchant_entry = MerchantEntry.find(params[:id])

    respond_to do |format|
      if @merchant_entry.update_attributes(params[:merchant_entry])
        format.html { redirect_to(adminpanel_merchant_entries_path, :notice => 'MerchantEntry 更新成功。') }
        format.json
      else
        format.html { render :action => "edit" }
        format.json
      end
    end
  end


  def destroy

    @merchant_entry = MerchantEntry.find(params[:id])
    @merchant_entry.destroy

    respond_to do |format|
      format.html { redirect_to(adminpanel_merchant_entries_path,:notice => "删除成功。") }
      format.json
    end
  end
end
