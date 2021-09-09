class RoomsController < ApplicationController

  def create
    @room = Room.create
    @entry1 = Entry.create(:room_id => @room.id, :user_id => current_user.id) #現在ログインしているユーザーのidをentryテーブルに保存
    @entry2 = Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(:room_id => @room.id)) #フォローされている側の情報
    #fields_for @entryで保存したparamsの情報(:user_id, :room_id)を許可,@roomにひもづくidを保存
    redirect_to "/rooms/#{@room.id}" #チャットルームが開く
  end

  def show
    @room = Room.find(params[:id]) #１つのチャットルームを表示
    if Entry.where(:user_id => current_user.id, :room_id => @room.id).present? #Entriesテーブルに、現在ログインしているユーザーのidとそれにひもづいたチャットルームのidをwhereメソッドで探し、そのレコードがあるか確認
      @messages = @room.messages ##Messageテーブルにそのチャットルームのidと紐づいたメッセージを表示
      @message = Message.new #新しくメッセージを作成
      @entries = @room.entries ##ユーザーの名前などの情報を表示させるため,Entriesテーブルのuser_idの情報を取得（ビューの方で記述）
    else
      redirect_back(fallback_location: root_path)
    end
  end
end
