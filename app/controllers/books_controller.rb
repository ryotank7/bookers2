class BooksController < ApplicationController
  before_action :authenticate_user!
   def new
  	@book = Book.new
  	@books = Book.page(params[:page]).reverse_order
    @user = current_user
  end

  def create
  	@book = Book.new(book_params)
  	@book.user_id = current_user.id
  	if @book.save
      flash[:notice] = "book was successfully created "
  		redirect_to book_path(@book.id)
  	else
      @books = Book.page(params[:page]).reverse_order
    @user = current_user
  		render :new
  	end
  end

  def update
    @book = Book.find(params[:id])

    if @book.update(book_params)
      flash[:notice] = "book was successfully updateed "
      redirect_to book_path(@book.id)
    else
      @books = Book.page(params[:page]).reverse_order
    @user = current_user
      render :edit
    end
  end

  def index
  	@books = Book.all
    @book = Book.new
  end

  def show
  	@book = Book.find(params[:id])
    @user = User.find_by(id: @book.user_id)
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user_id != current_user.id
      redirect_to books_path
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private
  	def book_params
  		params.require(:book).permit(:title, :body)
  	end
end
