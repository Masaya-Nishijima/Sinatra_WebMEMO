# frozen_string_literal: true

# myapp.rb
require 'sinatra'
require 'sinatra/reloader'

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
  file = File.new("memo_data/#{unique_name}", 'w')
  file.write(params[:memo_body])
  file.close
  redirect to('/memo')
end

delete '/memo/:memo_name' do # メモの削除メソッド
  params[:memo_name].delete!(DANGEROUS_STRING)
  File.delete("memo_data/#{params['memo_name']}")
  redirect to('/memo')
end

get '/memo/:memo_name/editor' do # メモの編集ページ
  erb :editor_memo
end

patch '/memo/:memo_name' do # メモの編集を実行
  params[:memo_name].delete!(DANGEROUS_STRING)
  params[:new_memo_name].delete!(DANGEROUS_STRING)
  unique_new_name = generate_unique_name(params[:new_memo_name])
  File.rename("#{Dir.getwd}/memo_data/#{params['memo_name']}", "#{Dir.getwd}/memo_data/#{unique_new_name}") if params['memo_name'] != params[:new_memo_name]
  file = File.new("memo_data/#{params[:new_memo_name]}", 'w+')
  file.write(params[:memo_body])
  file.close
  redirect to('/memo')
end

get '/memo/:memo_name' do # メモを表示
  redirect(not_found) if exists_memo?(params['memo_name'])
  erb :memo
end

#############################

# メモ一覧(ハイパーテキスト)を作成する。
def make_memo_list
  memo_name = Dir.glob('*', base: "#{Dir.getwd}/memo_data")
  list = ''
  memo_name.size.times do |time|
    list += make_a_tag(memo_name[time])
  end
  list
end

# メモの名前からhtmlのaタグリンクを作成するメソッド
def make_a_tag(memo_name)
  "<a href=\"/memo/#{memo_name}\">#{memo_name}</a><br />"
end

# メモを削除するフォーム(Deleteボタン)
def make_delete_form(_memo_name)
  @memo_name = params['memo_name']
  erb :delete_form
end

# メモの中身を取得するメソッド
def read_memo(memo_name)
  return '指定されたメモがありません' unless File.exist?("memo_data/#{params[:memo_name]}")

  h(File.open("memo_data/#{memo_name}", 'r', &:read))
end

def exists_memo?(memo_name)
  read_memo(params['memo_name']) == '指定されたメモがありません'
end


def generate_unique_name(memo_name)
  return memo_name unless File.exist?("memo_data/#{memo_name}")

  i = 2
  i += 1 while File.exist?("memo_data/#{memo_name}-" + i.to_s)
  "#{memo_name}-#{i}"
end
