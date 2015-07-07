require 'eventmachine'
require 'faye'

$client = Faye::Client.new('http://localhost:9292/faye')
$name = ARGV[0] || 'Anonymous'

module MyKeyboardHandler
  $buffer = ''

  def receive_data(keystrokes)
    # puts "I received the following data from the keyboard: #{keystrokes}"
    if keystrokes != "\n"
      $buffer << keystrokes
    else
      $client.publish('/chat', name: $name, text: $buffer)
      $buffer = ''
    end
  end
end

EM.run {
  $client.subscribe('/chat') do |message|
    puts "#{message['name']} said: #{message['text']}"
  end

  $client.publish('/chat', name: $name, text: 'Client connected')

  EM.open_keyboard(MyKeyboardHandler)
}
