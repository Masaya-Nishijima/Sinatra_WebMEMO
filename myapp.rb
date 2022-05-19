# frozen_string_literal: true

# myapp.rb
require 'sinatra'
require 'sinatra/reloader'
require 'pg'

DATABASE = PG.connect(dbname: 'sinatra_web_app')

get '/' do
  redirect to('/memo')
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

not_found do
  halt 404, '404 Not Found'
end

get '/memo' do # メモ一覧の表示
  @all_memo_names = DATABASE.exec('SELECT memo_name, id FROM memo')
  erb :memo_list
end

get '/memo/new_memo' do # メモの作成フォームを表示
  erb :new_memo
end

post '/memo' do # メモを作成
  DATABASE.exec_params('INSERT INTO memo (memo_name, memo_body) values ($1, $2)', [params[:memo_name], params[:memo_body]])
  redirect to('/memo')
end

delete '/memo/:memo_id' do # メモの削除メソッド
  DATABASE.exec_params('DELETE FROM memo WHERE id = $1', [params[:memo_id]])
  redirect to('/memo')
end

get '/memo/:memo_id/editor' do # メモの編集ページ
  get_memo(params[:memo_id])
  erb :editor_memo
end

patch '/memo/:memo_id' do # メモの編集を実行
  DATABASE.exec_params('UPDATE memo SET memo_name = $1, memo_body = $2 WHERE id = $3', [params[:new_memo_name], params[:memo_body], params[:memo_id]])
  redirect to('/memo')
end

get '/memo/:memo_id' do # メモを表示
  get_memo(params[:memo_id])

  erb :memo
end

##### ↑ルーティング ↓メソッド #####

def get_memo(memo_id)
  @memo = DATABASE.exec_params('SELECT * FROM memo WHERE id = $1', [memo_id]).first
  redirect(not_found) if @memo.nil?
end
