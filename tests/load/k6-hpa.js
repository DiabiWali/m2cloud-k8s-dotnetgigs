import http from 'k6/http';
import { sleep, check } from 'k6';

export const options = {
  stages: [
    { duration: '30s', target: 20 },
    { duration: '90s', target: 50 },
    { duration: '30s', target: 0 },
  ],
  thresholds: {
    http_req_failed: ['rate<0.10'],
    http_req_duration: ['p(95)<2000'],
  },
};

export default function () {
  const baseUrl = __ENV.BASE_URL || 'https://dotnetgigs.local';
  const res = http.get(baseUrl, { timeout: '5s', responseType: 'text' });
  check(res, { 'status is 2xx/3xx': (r) => r.status >= 200 && r.status < 400 });
  sleep(1);
}
