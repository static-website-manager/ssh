#!/usr/bin/ruby

require 'sequel'

DB = Sequel.connect("postgres://#{ENV['DATABASE_USERNAME']}:#{ENV['DATABASE_PASSWORD']}@#{ENV['DATABASE_HOST']}:5432/#{ENV['DATABASE_NAME']}")

keys = []

DB[:authentications].to_hash(:user_id, :public_key).each do |user_id, public_key|
  keys << "command=\"/etc/ssh/authorized_actions.rb #{user_id}\",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty #{public_key}"
end

puts keys.join("\n")
