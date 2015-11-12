#!/usr/bin/ruby

require 'sequel'

keys = []
DB = Sequel.connect('postgres://postgres@postgres:5432/postgres')

DB[:authentications].to_hash(:user_id, :public_key).each do |user_id, public_key|
  keys << "command=\"/home/git/allowed_actions.rb #{user_id}\",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty #{public_key}"
end

puts keys.join("\n")
