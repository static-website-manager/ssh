#!/usr/bin/ruby

require 'sequel'
require 'shellwords'

if ENV['SSH_CONNECTION'].to_s.empty?
  abort 'Only SSH Connections Allowed'
end

if !ARGV.is_a?(Array) || ARGV.length != 1
  abort 'Expected Single Argument Array'
end

user_id = ARGV[0].to_s

if !user_id.match(/\A\d{1,9}\z/)
  abort 'Expected User ID'
end

DB = Sequel.connect("postgres://#{ENV['DATABASE_USERNAME']}:#{ENV['DATABASE_PASSWORD']}@#{ENV['DATABASE_HOST']}:5432/#{ENV['DATABASE_NAME']}")

user = DB[:users].where(id: user_id.to_i).first
command, *args = Shellwords.shellsplit(ENV['SSH_ORIGINAL_COMMAND'].to_s)

if user.nil?
  abort 'No User Found'
elsif command.nil? || command.empty?
  puts "Hi #{user[:name]}! You have authenticated successfully, but Static Website Manager does not provide shell access. Goodbye."
  exit true
elsif %w[git-upload-pack git-receive-pack git-upload-archive].include?(command)
  if args.length == 1 && repo_id_match = args[0].match(/\A\/?(\d{1,9})(\.git)?\z/)
    if website = DB[:websites].where(id: repo_id_match[1].to_i).first
      if authorization = DB[:authorizations].where(user_id: user[:id], website_id: website[:id]).first
        if authorization[:ssh_access]
          exec "#{command} /repos/#{repo_id_match[1]}.git"
        else
          abort 'Your SSH Access Setting Is Not Enabled'
        end
      else
        abort 'Not Authorized'
      end
    else
      abort 'Not Repository Found'
    end
  else
    abort "Unsupported Repository Name #{args}"
  end
else
  abort "Unsupported Command: #{command} #{args}"
end
