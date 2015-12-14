class PostsController < ApplicationController
	# before_action :authenticate_user!, except: [:index, :show]

	def index
		@posts = Post.where(post_type: "blog").order('created_at DESC').includes(:images)
	end

	def new
		@action = request.filtered_parameters['action']
		@post = Post.new
	end

	def show
		@post = Post.find(params[:id])
	end

	def create
		params[:post][:video_url].gsub!(/watch\?v=/,"embed/") if params[:post][:video_url] != nil
		@image_file = params[:post].delete(:image_file)
		@post = Post.new(post_params)
		if @post.save
			if @image_file.present?
				@post.images.create(local_image: @image_file, caption: @image_file.original_filename)
			end
			redirect_to @post
		else
			render 'new'
		end
	end

	def edit
		@post = Post.find(params[:id])
	end

	def update
		params[:post][:video_url].gsub!(/watch\?v=/,"embed/") if params[:post][:video_url] != nil
		@image_file = params[:post].delete(:image_file)
		@post = Post.find(params[:id])

		if @post.update(params[:post].permit(:title, :body, :video_url))
			if !@image_file.nil?
				@post.images.delete_all
				@post.images.create(local_image: @image_file, caption: @image_file.original_filename)
			end
			redirect_to @post
		else
			render 'edit'
		end
	end

	def destroy
		@post = Post.find(params[:id])
		type = @post.post_type
		@post.destroy

		redirect_to blog_path if type == "blog"
		redirect_to press_path if type == "press"

	end

	private

	def post_params
		params.require(:post).permit(:title, :body, :image,:post_type, :video_url)
	end
end
