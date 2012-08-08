class MerchantEntriesController < ApplicationController
  def index
    @merchant_entry = MerchantEntry.all.first
  end
  
  def download
    send_file("public/doc/apply.doc",
              :filename => "merchant_apply.doc")
  end

end