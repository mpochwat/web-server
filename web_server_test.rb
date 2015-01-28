require 'socket'
require 'json'

server = TCPServer.open(2004)

loop {
	client = server.accept
	request = ""
	while line = client.gets
		request << line
		break if request =~ /\r\n\r\n$/
	end

	request_list = request.split(" ")
	request_type = request_list[0]
	request_file = request_list[1][1..-1]
	request_http = request_list[2]

	if File.exists?(request_file)

		file = File.open(request_file)

		if request_type == "GET"
			client.puts "#{request_http} 200 OK \r\nDate: #{Time.now.ctime} \r\n\r\nContent-Type: text/html \r\nContent-Length: #{File.size(file)} \r\n\r\n#{file.read}"
		elsif request_type == "POST"
			post_request = request.split("Content-Length", 2)
			post_split = post_request[1].split(" ")
			json_data = post_split[2]
			params = JSON.parse(json_data)
			data = "<li>Name: #{params['viking']['name']}</li><li>Email: #{params['viking']['email']}</li>"
			client.puts "#{request_http} 200 OK \r\nDate: #{Time.now.ctime} \r\n\r\nContent-Type: text/html \r\nContent-Length: #{File.size(file)} \r\n\r\n"
			client.puts file.read.gsub("<%= yield %>", data)
		else

		end

		file.close
			
	else
		client.puts "#{request_http} 404 Not Found\r\n"
	end


	client.puts(Time.now.ctime)
	client.puts "Closing connection. Bye!"
	client.close
}

# Multi-threaded
	#Thread.start(server.accept) do |client|
	#	client.puts(Time.now.ctime)
	#	client.puts "Closing conn"
	#	client.close
	#end