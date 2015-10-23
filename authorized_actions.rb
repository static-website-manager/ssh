#!/usr/bin/ruby

unless ENV['SSH_CONNECTION']
  puts 'Only ssh allowed'
  exit
end

require 'sequel'
require 'shellwords'

DB = Sequel.connect('postgres://postgres@postgres:5432/static_website_manager_development')

user = DB[:users].where(id: ARGV).first

if user
  def exec_git_command(user, git_command, repo_path)
    exec [git_command, repo_path].join(' ')
  end

  args = Shellwords.shellsplit(ENV['SSH_ORIGINAL_COMMAND'].to_s)

  if %w[git-upload-pack git-receive-pack git-upload-archive].include?(args[0]) && args.length == 2
    exec_git_command user, *args
    exit 0
  elsif args.empty?
    $stdout.puts "Hi #{user[:name]}! Static Website Manager does not provide shell access."
    exit 0
  else
    $stderr.puts 'Not Authorized'
    exit 1
  end
else
  $stderr.puts 'Not Authorized'
  exit 1
end
