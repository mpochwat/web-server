require 'socket'
require 'json'

hostname = 'localhost'
port = 2004
path = '/index.html'
path2 = '/thanks.html'

puts "What type of request would you like to send? (GET or POST)"
ans = gets.chomp.upcase
acceptable = false
request = ""

while !acceptable
	if ans == "GET"
		acceptable = true
		request = "GET #{path} HTTP/1.0 \r\nFrom: martinochwat1@gmail.com \r\nUser-Agent: HTTPTool/1.0 \r\n\r\n"
	elsif ans == "POST"
		acceptable = true
		puts "You are now registering a viking for a raid!"
		puts "What is the viking's name?"
		name = gets.chomp
		puts "What is the viking's email?"
		email = gets.chomp
		p viking = {:viking => {:name => "#{name}", :email => "#{email}"} }.to_json
		request = "POST #{path2} HTTP/1.0 \r\nFrom: martinochwat1@gmail.com \r\nUser-Agent: HTTPTool/1.0 \r\nContent-Length: #{viking.length} \r\n#{viking} \r\n\r\n"
	else
		puts "Sorry that is not a valid request. Try again."
		ans = gets.chomp
	end
end

socket = TCPSocket.open(hostname, port)
socket.print(request)
response = socket.read
headers, body = response.split("\r\n\r\n", 2)
print body