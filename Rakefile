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

desc '初期セットアップ'
task all: %i[install_gem files]

desc '初期化(要再セットアップ)'
task :clean do
  sh %(rm -r memo_data)
  sh %(rm -r public)
  sh %(rm Gemfile.lock)
end
