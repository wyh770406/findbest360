class ContactsController < ApplicationController
  def index
    @contact = Contact.all.first
  end

end