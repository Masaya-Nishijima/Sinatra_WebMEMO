# myapp.rb
require 'sinatra'
require 'sinatra/reloader'

# get '/' do
#   'This is WEB MEMO app'
#   '<h1>aaaa</h1>'
# end
get '/' do # メモ一覧の表示
  redirect to('/index.html')
end

get '/:memo_name' do # メモを表示
  read_memo(params['memo_name'])
  "
  参照したメモは#{params['memo_name']}です。内容は以下の通りです。<br />
  #{read_memo(params['memo_name'])} <br />
  以上です。
  "
end

post '/:memo_name' do # メモを作成
  if File.exist?('memo_data/' + params[:memo_name])
    '同名のメモがあります。タイトルを変えてください。'
  else
    'メモを作成しました'
  end
end


def read_memo(memo_title)
  return '指定されたメモがありません' if !File.exist?('memo_data/' + params[:memo_name])
  file = File.new("memo_data/" + memo_title, "r")
  memo_body = file.read
  file.close
  memo_body
end
