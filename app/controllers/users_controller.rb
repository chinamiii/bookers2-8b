class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @newbook = Book.new
    @books =@user.books

    @currentUserEntry=Entry.where(user_id: current_user.id) #1ログインしてるユーザーをエントリーテーブルに記録
    @userEntry=Entry.where(user_id: @user.id) #2相手のユーザーをエントリーテーブルに記録

    if @user.id == current_user.id #いまログインしてる？
    else
      @currentUserEntry.each do |cu| #1ログインしてるユーザー
        @userEntry.each do |u| #2相手のユーザー
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id #room_idが共通しているのユーザー同士に対して
            #これですでに作成されているroom_idを特定できる
          end
        end
      end
      if @isRoom　#新しくインスタンスを生成
      else
        @room = Room.new
        @entry = Entry.new
      end
    end


    @today_book =  @books.created_today
    @yesterday_book = @books.created_yesterday

    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
  end



  def index
    @users = User.all
    @newbook = Book.new
  end

  def edit
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to user_path(current_user)
    end

  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
       redirect_to user_path(@user.id) ,notice: "You have updated user successfully."
    else
      render :edit
    end
  end


  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end
end
