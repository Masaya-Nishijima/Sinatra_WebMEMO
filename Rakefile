# frozen_string_literal: true

task :install_gem do
  sh %(bundler install)
end

directory 'memo_data'

directory 'public'

file 'public/stylesheet.css' => ['public'] do
  sh %(cp stylesheet.css public/stylesheet.css)
end

desc 'ディレクトリを構成'
task files: ['memo_data', 'public/stylesheet.css']

desc 'DB作成'
task :database do
  sh 'psql -U postgres -c "CREATE DATABASE sinatra_web_app"'
  sh 'psql -U postgres -c "CREATE TABLE memo (memo_name text, memo_body text, PRIMARY KEY (memo_name))" sinatra_web_app'
end

desc '初期セットアップ'
task all: %i[install_gem files database]

desc '初期化(要再セットアップ)'
task :clean do
  sh %(rm -r memo_data)
  sh %(rm -r public)
  sh %(rm Gemfile.lock)
  puts "安全のためpostgresqlのデータは自動削除していません。\nDATABASE名: sinatra_web_app ,TABLE名: memo"
  puts 'データベースごとの削除: DROP DATABASE sinatra_web_app'
end
