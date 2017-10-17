var http = require('http');


const PORT = 25000;
var responses = {};


function handle(request, response) {
    var msize = request.url.substr(1);
    if (!msize) {
        msize = 1024;
    } else {
        msize = parseInt(msize, 10);
    }
    if (responses[msize] !== undefined) {
	responses[msize] = Buffer.alloc(msize, "X");
    }
    response.end(responses[msize]);
}


var server = http.createServer(handle);


server.on("connect", function() {
  socket.setNoDelay(true);
});


server.listen(PORT, function() {
    console.log('Serving on ::' + PORT.toString());
});
