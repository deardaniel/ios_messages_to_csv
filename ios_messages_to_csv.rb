#!/usr/bin/env ruby

require 'rubygems'
require 'sqlite3'
require 'csv'

DB_NAME_INFO = "The database file is probably called 3d0d7e5fb2ce288813306e4d4636395e047a3d28, and in your iOS backup directory.";

if (ARGV.count < 1 || ARGV.count > 2)
  abort "usage: #{File.basename $0} sqlite3_database.sqlite3 [output.csv]\n\n#{DB_NAME_INFO}"
end

abort "error: file #{ARGV[0]} does not exist.\n\n#{DB_NAME_INFO}" unless (File.exists? ARGV[0])

headers_sent = false
db = SQLite3::Database.new(ARGV[0])
db.results_as_hash = true
if (ARGV.count == 2)
  csv = CSV.open(ARGV[1], "w")
else
  csv = CSV($stdout)
end

db.execute("select * from message") do |row|
  message = { :rowid => row['ROWID'], :date => Time.at(row['date']).utc, :address => [ row['address'] ], :text => row['text'] || "" }
  
  # Grab extra addresses from the recipients field
  unless row['recipients'].nil?
    message[:address] << row['recipients'].scan(/<string>(.*?)<\/string>/i).flatten
  end
  
  # Grab extra addresses from group_member
  db.execute("select address from group_member where group_id = #{row['group_id']}") do |grp|
    message[:address] << grp['address']
  end
  
  # Grab extra message content from msg_pieces
  db.execute("select * from msg_pieces where message_id = #{row['ROWID']}") do |piece|
    if piece['content_type'] == 'text/plain'
      message[:text] += piece['data']
    end
  end
  
  # Clean up address field
  message[:address] = message[:address].flatten.uniq { |s| s.nil? ? nil : s.gsub(/[^0-9]/, '') }.compact.join("\n")
  
  csv << message.keys unless headers_sent
  csv << message.values
    
  headers_sent = true
end
