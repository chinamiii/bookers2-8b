class BookCommentsController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    @comment = BookComment.new(book_comment_params)
    @comment.user = current_user
    @comment.book_id = @book.id
    @comment.save


  end

  def destroy
    @book = Book.find(params[:book_id])
    BookComment.find_by(id: params[:id], book_id: params[:book_id]).destroy



  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

end
