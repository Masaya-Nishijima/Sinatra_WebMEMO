# frozen_string_literal: true

# myapp.rb
require 'sinatra'
require 'sinatra/reloader'

# get '/' do
#   'This is WEB MEMO app'
#   '<h1>aaaa</h1>'
# end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

not_found do
  halt 404, '404 Not Found'
end

get '/' do # メモ一覧の表示
  erb :memo_list
  # redirect to('/index.html')
end

get '/new_memo' do # メモの作成フォームを表示
  erb :new_memo
end

post '/new_memo' do # メモを作成
  redirect to('/already_memo') if File.exist?("memo_data/#{params[:memo_name]}")

  file = File.new("memo_data/#{params[:memo_name]}", 'w')
  file.write(params[:memo_body])
  file.close
  redirect to('/')
end

get '/already_memo' do # 作成したメモに同名のものがある、空欄のときのリダイレクト先
  erb :already_memo
end

delete '/:memo_name' do # メモの削除メソッド
  File.delete("memo_data/#{params['memo_name']}")
  redirect to('/')
end

get '/:memo_name/editor' do # メモの編集ページ
  erb :editor_memo
end

patch '/:memo_name' do # メモの編集を実行
  if params['memo_name'] != params[:new_memo_name]
    File.rename("#{Dir.getwd}/memo_data/#{params['memo_name']}", "#{Dir.getwd}/memo_data/#{params[:new_memo_name]}")
  end
  file = File.new("memo_data/#{params[:new_memo_name]}", 'w+')
  file.write(params[:memo_body])
  file.close
  redirect to('/')
end

get '/:memo_name' do # メモを表示
  redirect(not_found) if read_memo(params['memo_name']) == '指定されたメモがありません'
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
  "<a href=\"#{memo_name}\">#{memo_name}</a><br />"
end

# メモを削除するフォーム(Deleteボタン)
def make_delete_form(memo_name)
  @memo_name = params['memo_name']
  erb :delete_form
end

# メモの中身を取得するメソッド
def read_memo(memo_name)
  return '指定されたメモがありません' unless File.exist?("memo_data/#{params[:memo_name]}")

  h(File.open("memo_data/#{memo_name}", 'r', &:read))
end
