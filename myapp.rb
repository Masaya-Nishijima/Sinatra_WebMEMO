# frozen_string_literal: true

# myapp.rb
require 'sinatra'
require 'sinatra/reloader'

enable :method_override # メソッドオーバーライドを許可する。
# get '/' do
#   'This is WEB MEMO app'
#   '<h1>aaaa</h1>'
# end

get '/' do # メモ一覧の表示
  "
  既存のメモリストです。<br />
  #{make_memo_list}
  以上です。<br /> <br/>
  <a href=\"/new_memo\">メモを作成する<br />
  <a href=\"/delete_memo\">メモを連続削除する<br />
  "
  # redirect to('/index.html')
end

get '/new_memo' do
  '
  メモ作成フォームです。
  <form method="post" action="">
    <div>
      <label>
        メモの名前
        <input type="text" name="memo_name">
      </label>
      <br />
      <label>
        メモの内容
        <input type="text" name="memo_body">
      </label>
    </div>
    <button type="submit">送信</button>
  </form>
  '
end

post '/new_memo' do # メモを作成
  redirect to('/already_memo') if File.exist?("memo_data/#{params[:memo_name]}")

  file = File.new("memo_data/#{params[:memo_name]}", 'w')
  file.write(params[:memo_body])
  file.close
  redirect to('/create_memo')
end

get '/already_memo' do
  '
  名前が空欄、もしくは同名のメモがあります。タイトルを変え作成しなおしてください。<br />
  <a href=/new_memo>メモを再度作成。<br />
  '
end

get '/create_memo' do
  'メモを作成しました。 <br />
   <a href="/">メモ一覧へ<br />'
end

get '/delete_memo' do
  "
  <a href=\"/\">メモ一覧へ</a><br />
  #{make_delete_list}
  "
end

delete '/:memo_name' do
  File.delete("memo_data/#{params['memo_name']}")
  redirect to('/delete_memo')
end

get '/:memo_name' do # メモを表示
  "
  参照したメモは#{params['memo_name']}です。内容は以下の通りです。<br />
  #{read_memo(params['memo_name'])} <br />
  以上です。 <br /><br />
  <a href=\"/#{params['memo_name']}/editor\">メモを編集する。</a><br />
  #{make_delete_form(params['memo_name'])}
  <a href=\"/\">メモ一覧へ</a><br />
  "
end

get '/:memo_name/editor' do
  "
  編集中のメモは#{params['memo_name']}です。
  <form method=\"post\" action=\"/#{params['memo_name']}\">
    <input type=\"hidden\" name=\"_method\" value=\"patch\"> <br />
    タイトル
    <input type=\"text\", name=\"new_memo_name\" value=#{params['memo_name']}> <br />
    内容
    <input type=\"text\", name=\"memo_body\" value=#{read_memo(params['memo_name'])}> <br />
    <input type=\"submit\" value=\"変更を保存\">
  </form>
  <br />
  "
end

patch '/:memo_name' do
  if params['memo_name'] != params[:new_memo_name]
    File.rename("#{Dir.getwd}/memo_data/#{params['memo_name']}", "#{Dir.getwd}/memo_data/#{params[:new_memo_name]}")
  end
  file = File.new("memo_data/#{params[:new_memo_name]}", 'w+')
  file.write(params[:memo_body])
  file.close
  redirect to('/')
end

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

def make_delete_list
  files = Dir.glob('*', base: "#{Dir.getwd}/memo_data")
  list = ''
  files.size.times do |time|
    list += make_delete_form(files[time])
  end
  list
end

def make_delete_form(memo_name)
  "
  <form method=\"post\" action=\"/#{memo_name}\">
    #{memo_name}
    <input type=\"hidden\" name=\"_method\" value=\"delete\">
    <input type=\"submit\" value=\"delete\">
  </form>
  <br />
    "
end

# メモの中身を取得するメソッド
def read_memo(memo_name)
  return '指定されたメモがありません' unless File.exist?("memo_data/#{params[:memo_name]}")

  File.open("memo_data/#{memo_name}", 'r', &:read)
end
