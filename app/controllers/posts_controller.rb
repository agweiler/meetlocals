class PostsController < ApplicationController
	# before_action :authenticate_user!, except: [:index, :show]

	def index
		@posts = Post.all.order('created_at DESC')
	end

	def new
		@post = Post.new
	end

	def show
		@post = Post.find(params[:id])
	end

	def create
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
		@image_file = params[:post].delete(:image_file)
		@post = Post.new(post_params)
		if @image_file.present?
			@post.images.delete_all
		end
		@post.images.create(local_image: @image_file, caption: @image_file.original_filename)
		@post = Post.find(params[:id])
	end

	def update
		@post = Post.find(params[:id])

		if @post.update(params[:post].permit(:title, :body))
			redirect_to @post
		else
			render 'edit'
		end
	end

	def destroy
		@post = Post.find(params[:id])
		@post.destroy

		redirect_to posts_path
	end

	private

	def post_params
		params.require(:post).permit(:title, :body, :image)
	end
end
