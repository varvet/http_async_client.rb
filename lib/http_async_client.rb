require "java"
require "http_async_client/version"
require "http_async_client/commons-codec-1.6"
require "http_async_client/commons-logging-1.1.3"
require "http_async_client/httpcore-4.3"
require "http_async_client/httpcore-nio-4.3"
require "http_async_client/httpclient-4.3.1"
require "http_async_client/httpasyncclient-4.0"

module HttpAsyncClient

  class << self
    def client
      @client ||= begin
        client = org.apache.http.impl.nio.client.HttpAsyncClients.create_default
        client.start
        at_exit { client.close }
        client
      end
    end

    def get(url)
      request = org.apache.http.client.methods.HttpGet.new(url)
      Future.new(client.execute(request, nil))
    end
  end

  class Future
    def initialize(java_future)
      @java_future = java_future
    end

    def get
      Response.new(@java_future.get)
    end
  end

  class Response
    def initialize(java_response)
      @java_response = java_response
    end

    def code
      @java_response.status_line.status_code
    end

    def body
      @body ||= @java_response.entity.content.to_io.read
    end

    def stream
      @java_response.entity.content
    end
  end
  # Your code goes here...
end
