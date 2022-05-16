# frozen_string_literal: true

# myapp.rb
require 'sinatra'
require 'sinatra/reloader'
require 'pg'

DATABASE = PG.connect(dbname: 'sinatra_web_app')

DANGEROUS_STRING = '/.<>'

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
  erb :memo_list
end

get '/memo/new_memo' do # メモの作成フォームを表示
  erb :new_memo
end

post '/memo' do # メモを作成
  params[:memo_name].delete!(DANGEROUS_STRING)
  unique_name = generate_unique_name(params[:memo_name])
  DATABASE.exec("INSERT INTO memo values ('#{unique_name}', '#{params[:memo_body]}')")
  redirect to('/memo')
end

delete '/memo/:memo_name' do # メモの削除メソッド
  params[:memo_name].delete!(DANGEROUS_STRING)
  DATABASE.exec("DELETE FROM memo WHERE memo_name = '#{params[:memo_name]}'")
  redirect to('/memo')
end

get '/memo/:memo_name/editor' do # メモの編集ページ
  erb :editor_memo
end

patch '/memo/:memo_name' do # メモの編集を実行
  params[:memo_name].delete!(DANGEROUS_STRING)
  params[:new_memo_name].delete!(DANGEROUS_STRING)
  params[:memo_body].delete!(DANGEROUS_STRING)
  unique_new_name = generate_unique_name(params[:new_memo_name])
  DATABASE.exec("UPDATE memo SET memo_name = '#{unique_new_name}', memo_body = '#{params[:memo_body]}' WHERE memo_name = '#{params[:memo_name]}'")
  redirect to('/memo')
end

get '/memo/:memo_name' do # メモを表示
  memo_data = DATABASE.exec("SELECT * FROM memo WHERE memo_name = '#{params[:memo_name]}'").values[0]
  redirect(not_found) if memo_data.nil?
  @memo = { memo_name: memo_data[0], memo_body: memo_data[1] }

  erb :memo
end

#############################

def generate_unique_name(memo_name)
  already_memo_names = DATABASE.exec('SELECT memo_name FROM memo').values.flatten
  return memo_name if already_memo_names.find { |already_memo_name| already_memo_name == memo_name }.nil?

  i = 2
  i += 1 until already_memo_names.find { |already_memo_name| already_memo_name == ("#{memo_name}-#{i}") }.nil?
  "#{memo_name}-#{i}"
end
