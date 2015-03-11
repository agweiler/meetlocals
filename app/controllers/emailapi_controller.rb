class EmailapiController < ApplicationController

  validates :email 
    

    def subscribe


        @list_id = "682ba11451"
        gb = Gibbon::API.new

        if gb.lists.subscribe({
          :id => @list_id,
          :email => {:email => params[:email][:address]}
          })
          flash[:success] = "Please check the supplied email to confirm your subscription!"
          # redirect_to root_path, :flash => { :success => "Message" }
          redirect_to "/"
        else 
          redirect_to "/"
        end

    end

end
