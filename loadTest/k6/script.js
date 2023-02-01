import http from 'k6/http';
import { sleep, check } from 'k6';
import exec from 'k6/execution';

const token = `${__ENV.TOKEN}`
const wait  = 1
const url   = "http://stationback.exakaconsulting.org/StationDemoSecureWeb/station/stations"

const params = {
    headers: {
      'Content-Type': 'application/json',
      'Authorization' : "Bearer " + token
    },
};

// Read data file
let data = open(__ENV.LOAD_FILE_TEST).split("\n");
let nbrData = data.length;

export const options = {
    thresholds: {
      http_req_failed: ['rate<3'], // http errors should be less than 3%
      http_req_duration: ['p(95)<13000'], // 95% of requests should be below 13s
    },
  };

export default function () {

  // Calcul index
  let counter = exec.scenario.iterationInTest;
  let index   = counter%nbrData;
  let urlTest = url + data[index];
  console.log("Url test : " + urlTest);

  const res = http.get(urlTest, params);
  check(res, {
    'is status 200': (r) => r.status === 200,
  });
  sleep(wait);
}