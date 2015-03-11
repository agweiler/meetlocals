class EmailapiController < ApplicationController
  include EmailapiHelper

  def subscribe
    email = params[:email][:address]
    respond_to do |format|
      if is_a_valid_email?(email)
        @list_id = "682ba11451"
        gb = Gibbon::API.new

        gb.lists.subscribe({
          :id => @list_id,
          :email => {:email => email}
        })
        format.json { render json: {msg: "Please check your supplied email to confirm subscription!" }}
      else
        format.json { render json: {msg: "Invalid email" }}
      end
    end
  end
end
