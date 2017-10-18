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
