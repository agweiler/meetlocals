class StaticTextsController < ApplicationController
	before_action :set_static_texts, only: [:edit, :update]
	def index
		@static_text = StaticText.all.order(:id)
	end

	def edit
	end

	def update
		params[:static_text][:video_url].gsub!(/watch\?v=/,"embed/") if params[:static_text][:video_url] != nil
		@static_text.update(static_text_params)
		redirect_to static_texts_path
	end

	private
		def set_static_texts
			@static_text = StaticText.find(params[:id])
		end

		def static_text_params
			params.require(:static_text).permit(:content, :video_url)
		end
end
