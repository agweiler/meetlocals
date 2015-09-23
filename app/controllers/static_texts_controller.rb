class StaticTextsController < ApplicationController
	before_action :set_static_texts, only: [:edit, :update]
	def index
		@static_text = StaticText.all
	end

	def edit
	end

	def update
		@static_text.update(content: params[:static_text][:content])
		redirect_to static_texts_path
	end

	private
		def set_static_texts
			@static_text = StaticText.find(params[:id])
		end
end
