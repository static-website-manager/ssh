#!/usr/bin/ruby

require 'sequel'

DB = Sequel.connect('postgres://postgres@postgres:5432/static_website_manager_development')

keys = []

DB[:authentications].to_hash(:id, :public_key).each do |id, public_key|
  keys << "command=\"/etc/ssh/authorized_actions.rb #{id}\",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty #{public_key}"
end

puts keys.join("\n")
