# config.ru

require 'faye'
require 'thin'

Faye::WebSocket.load_adapter('thin')
Faye.logger = Logger.new(STDOUT)
Faye.logger.level = Logger::DEBUG

app = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)
run app
