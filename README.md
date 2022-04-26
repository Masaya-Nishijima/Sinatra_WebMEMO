# Sinatra(Ruby)で動くメモアプリ

# 1. 起動方法

初回セットアップ
> $ rake all

サーバーの起動
> $ ruby myapp.rb

# 2. URIの構成
- GET`/memo`
  - メモ一覧を表示

    (ドメイン名が`~memo-list~.com`や`~memo-app~.com`のようにメモアプリであることが明示されていることを想定したため、ルートがメモ一覧)

- GET`/memo/{メモの名前}`
  - メモを表示

- GET `/not_found`
  - 指定されたメモがないときのリダイレクト先(status 404)

- GET `/memo/new_memo`
  - メモの作成フォームを表示

- POST `/memo/new_memo`
  - メモを作成

- ~GET `/create_memo`~
  - ~メモを正しく作成できたときのリダイレクト先~

- ~GET `/already_memo`~
  - ~作成したメモに同名のものがある、空欄のときのリダイレクト先~

- GET`/memo/{メモの名前}/editor`
  - メモの編集フォームを表示

- PATCH `/memo/{メモの名前}`
  - メモの編集

- DELETE `/memo/{メモの名前}`
  - メモの削除メソッド
