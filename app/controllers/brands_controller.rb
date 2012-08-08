class BrandsController < ApplicationController
    before_filter :authenticate_user!, :only => [:new_comment]
  # GET /brands
  # GET /brands.json
  def index
    if params[:product_id]
      @product = TopProduct.find(params[:product_id])
      @brands = @product.brands.page(params[:page]).per(18)
    else
      @brands = Brand.all.page(params[:page]).per(18)
    end
    
    @products = TopProduct.all.asc("order_num")


    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @brands }
    end
  end

  # GET /brands/1
  # GET /brands/1.json
  def show
    @brand = Brand.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @brand }
    end
  end

  # GET /brands/new
  # GET /brands/new.json
  def new
    @brand = Brand.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @brand }
    end
  end

  # GET /brands/1/edit
  def edit
    @brand = Brand.find(params[:id])
  end

  # POST /brands
  # POST /brands.json
  def create
    @brand = Brand.new(params[:brand])

    respond_to do |format|
      if @brand.save
        format.html { redirect_to @brand, :notice => 'Brand was successfully created.' }
        format.json { render :json => @brand, :status=> :created, :location=> @brand }
      else
        format.html { render :action=> "new" }
        format.json { render :json => @brand.errors, :status=> :unprocessable_entity }
      end
    end
  end

  # PUT /brands/1
  # PUT /brands/1.json
  def update
    @brand = Brand.find(params[:id])

    respond_to do |format|
      if @brand.update_attributes(params[:brand])
        format.html { redirect_to @brand, :notice => 'Brand was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action=> "edit" }
        format.json { render :json => @brand.errors, :status=> :unprocessable_entity }
      end
    end
  end

  # DELETE /brands/1
  # DELETE /brands/1.json
  def destroy
    @brand = Brand.find(params[:id])
    @brand.destroy

    respond_to do |format|
      format.html { redirect_to brands_url }
      format.json { head :ok }
    end
  end
  
  #comments
  def comments
    @brand = Brand.find params[:id]
    if request.post?
      @comment = BrandComment.new(params[:brand_comment])
      @comment.brand_id = @brand.id
      @comment.user_id = current_user.id if current_user
      @comment.ip = request.ip
      if @comment.valid?
        @comment.save!
      end
    end
    @comments = @brand.brand_comments.page(params[:page]).per(10)
  end

end
