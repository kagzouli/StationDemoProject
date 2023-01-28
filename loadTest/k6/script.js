import http from 'k6/http';
import { sleep, check } from 'k6';

const token = `${__ENV.TOKEN}`
const wait  = 1
const url   = "http://stationback.exakaconsulting.org/StationDemoSecureWeb/station/stations"

const params = {
    headers: {
      'Content-Type': 'application/json',
      'Authorization' : "Bearer " + token
    },
};

export const options = {
    thresholds: {
      http_req_failed: ['rate<0.1'], // http errors should be less than 1%
      http_req_duration: ['p(95)<5000'], // 95% of requests should be below 5s
    },
  };

export default function () {
  const res = http.get(url, params);
  check(res, {
    'is status 200': (r) => r.status === 200,
  });
  sleep(wait);
}