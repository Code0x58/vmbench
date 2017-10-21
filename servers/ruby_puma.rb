require 'rack'
require 'rack/handler/puma'
# ruby actually sets TCP_CORK instead of TCP_NODELAY
# https://github.com/puma/puma/blob/v3.10.0/lib/puma/server.rb#L100

app = Rack::Builder.new do
    @cache = {}
    def call(env)
        size = Integer(env['PATH_INFO'][1..-1]) rescue 1024
        body = @cache[size]
        if body.nil?
            body = @cache[size] = 'X' * size
        end
        [200, {}, [body]]
    end
end

Rack::Server.start app: app, Port: 25000,
    max_threads: 1, workers: 0, environment: 'none'
