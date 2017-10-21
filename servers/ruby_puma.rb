# ruby actually sets TCP_CORK instead of TCP_NODELAY
# https://github.com/puma/puma/blob/v3.10.0/lib/puma/server.rb#L100
require 'rack/handler/puma'


$cache = {}
app = proc do |env|
    size = Integer(env['PATH_INFO'][1..-1]) rescue 1024
    if not $cache.key?(size)
        $cache[size] = 'X' * size
    end
    [200, {}, [$cache[size]]]
end

Rack::Handler::Puma.run(app, Port: 25000, max_threads: 1, workers: 0, preload_app: true)
