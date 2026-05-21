const http = require('http');

const port = process.env.PORT || 8080;
const appName = 'hello-api';
const version = process.env.APP_VERSION || '1.0.0';

const server = http.createServer((req, res) => {
  if (req.url === '/metrics') {
    res.setHeader('Content-Type', 'text/plain');
    res.statusCode = 200;
    res.end(`# HELP app_up Application availability\n# TYPE app_up gauge\napp_up{service="${appName}"} 1\n`);
    return;
  }

  res.setHeader('Content-Type', 'application/json');

  if (req.url === '/health') {
    res.statusCode = 200;
    res.end(JSON.stringify({ status: 'ok', service: appName }));
    return;
  }

  if (req.url === '/version') {
    res.statusCode = 200;
    res.end(JSON.stringify({ service: appName, version }));
    return;
  }

  if (req.url === '/api/hello') {
    res.statusCode = 200;
    res.end(JSON.stringify({
      message: `Hello from ${appName}`,
      platform: 'M2Cloud Kubernetes Platform'
    }));
    return;
  }

  res.statusCode = 404;
  res.end(JSON.stringify({ error: 'not_found' }));
});

server.listen(port, '0.0.0.0', () => {
  console.log(`${appName} listening on port ${port}`);
});
