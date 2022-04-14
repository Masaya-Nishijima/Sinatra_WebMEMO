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
  <link rel=\"styleshee\" href=\"stylesheet.css\">
  <h1>既存のメモリストです。</h1>
  #{make_memo_list}
  <br /> <br/>
  <a href=\"/new_memo\">メモを作成する<br />
  "
  # redirect to('/index.html')
end

get '/new_memo' do # メモの作成フォームを表示
  '
  <link rel="stylesheet" href="stylesheet.css">
  <article>
  <h1>メモ作成フォームです。</h1>
  <section>
  <form method="post" action="">
    <div>
      <label><input type="text" name="memo_name" value="メモの名前"></label> <br />
      <label><textarea name="memo_body">メモの内容</textarea></label>
    </div>
    <input type="submit" value="送信">
  </section>
  </form>
  </article>
  '
end

post '/new_memo' do # メモを作成
  redirect to('/already_memo') if File.exist?("memo_data/#{params[:memo_name]}")

  file = File.new("memo_data/#{params[:memo_name]}", 'w')
  file.write(params[:memo_body])
  file.close
  redirect to('/create_memo')
end

get '/already_memo' do # 作成したメモに同名のものがある、空欄のときのリダイレクト先
  '
  <link rel="stylesheet" href="stylesheet.css">
  <h1>メモの作成に失敗</h1>
  <p>名前が空欄、もしくは同名のメモがあります。<br />タイトルを変え作成しなおしてください。</p>
  <a href=/new_memo>メモを再度作成。<br />
  '
end

get '/create_memo' do # メモを正しく作成できたときのリダイレクト先
  '
  <link rel="stylesheet" href="stylesheet.css">
  <h1>メモを作成しました。</h1>
  <a href="/">メモ一覧へ</a>
  '
end

delete '/:memo_name' do # メモの削除メソッド
  File.delete("memo_data/#{params['memo_name']}")
  redirect to('/')
end

get '/:memo_name/editor' do # メモの編集ページ
  "
  <link rel=\"stylesheet\" href=\"/stylesheet.css\">
  <article>
  <section>
  <h1>#{params['memo_name']}を編集中</h1>
  <form method=\"post\" action=\"/#{params['memo_name']}\">
    <input type=\"hidden\" name=\"_method\" value=\"patch\"> <br />
    <div>
      <label><input type=\"text\", name=\"new_memo_name\" value=#{params['memo_name']}></label> <br />
      <label><textarea name=\"memo_body\">#{read_memo(params['memo_name'])}</textarea></label>
    </div>
    <input type=\"submit\" value=\"変更を保存\">
  </section>
  </article>
  </form>
  <br />
  "
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
  "
  <link rel=\"stylesheet\" href=\"/stylesheet.css\">
  <article>
  <section>
  <h1>#{params['memo_name']}</h1>
  <p>#{read_memo(params['memo_name'])}</p>
  </section>
  <a href=\"/#{params['memo_name']}/editor\">メモを編集する。</a><br />
  #{make_delete_form(params['memo_name'])}
  <a href=\"/\">メモ一覧へ</a>
  </article>
  "
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
  "
  <form method=\"post\" action=\"/#{memo_name}\">
    <input type=\"hidden\" name=\"_method\" value=\"delete\">
    <input type=\"submit\" value=\"メモを削除\">
  </form>
  <br />
    "
end

# メモの中身を取得するメソッド
def read_memo(memo_name)
  return '指定されたメモがありません' unless File.exist?("memo_data/#{params[:memo_name]}")

  File.open("memo_data/#{memo_name}", 'r', &:read)
end
