# app/bot/listen.rb
require "facebook/messenger"

include Facebook::Messenger

Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["ACCESS_TOKEN"])

Bot.on :message do |message|
  puts message.id          # => 'mid.1457764197618:41d102a3e1ae206a38'
  puts message.sender      # => { 'id' => '1008372609250235' }
  puts message.seq         # => 73
  puts message.sent_at     # => 2016-04-22 21:30:36 +0200
  puts message.text        # => 'Hello, bot!'
  puts message.attachments # => [ { 'type' => 'image', 'payload' => { 'url' => 'https://www.example.com/1.jpg' } } ]

  message.reply(text: 'Hello, human!')
end
