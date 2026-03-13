const http = require('http');

const port = process.env.PORT || 5000;

const request = http.get(
  { host: 'localhost', port, path: '/health', timeout: 3000 },
  (response) => {
    response.resume();
    process.exit(response.statusCode === 200 ? 0 : 1);
  }
);

request.on('error', (error) => {
  console.error('Healthcheck failed:', error.message);
  process.exit(1);
});
request.on('timeout', () => {
  request.destroy();
  process.exit(1);
});
