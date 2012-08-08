# encoding: utf-8
class QuestionAdvicesController < ApplicationController
  def new


    @question_advice = QuestionAdvice.new

    respond_to do |format|
      format.html # new.html.erb
      format.json
    end
  end

  def create

    @question_advice = QuestionAdvice.new(params[:question_advice])

    respond_to do |format|
      if @question_advice.save

        format.html { redirect_to(new_question_advice_path,:notice => "疑问建议创建成功，你可以继续提疑问建议。") }
        format.json
      else
        format.html { render :action => "new" }
        format.json
      end
    end
  end
end