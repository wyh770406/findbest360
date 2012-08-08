# coding: UTF-8
class Adminpanel::QuestionAdvicesController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"
  def index

    @question_advices = QuestionAdvice.all.desc("created_at").page(params[:page]).per(300)

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end

  def show

    @question_advice = QuestionAdvice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json
    end
  end

  def new

    @question_advice = QuestionAdvice.new

    respond_to do |format|
      format.html # new.html.erb
      format.json
    end
  end

  def edit

    @question_advice = QuestionAdvice.find(params[:id])
  end

  def create

    @question_advice = QuestionAdvice.new(params[:question_advice])

    respond_to do |format|
      if @question_advice.save

        format.html { redirect_to(adminpanel_question_advices_path, :notice => 'QuestionAdvice 创建成功。') }
        format.json
      else
        format.html { render :action => "new" }
        format.json
      end
    end
  end

  def update

    @question_advice = QuestionAdvice.find(params[:id])

    respond_to do |format|
      if @question_advice.update_attributes(params[:question_advice])
        format.html { redirect_to(adminpanel_question_advices_path, :notice => 'QuestionAdvice 更新成功。') }
        format.json
      else
        format.html { render :action => "edit" }
        format.json
      end
    end
  end


  def destroy

    @question_advice = QuestionAdvice.find(params[:id])
    @question_advice.destroy

    respond_to do |format|
      format.html { redirect_to(adminpanel_question_advices_path,:notice => "删除成功。") }
      format.json
    end
  end
end
