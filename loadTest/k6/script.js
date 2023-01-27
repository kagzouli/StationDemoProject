import http from 'k6/http';
import { sleep, check } from 'k6';

const token = "1eyJraWQiOiI1dUt0QlVBa0tON1VxV3Y2OUdBWW5YeER4cjVScHlWUUxzWXhRQnRfek1jIiwiYWxnIjoiUlMyNTYifQ.eyJ2ZXIiOjEsImp0aSI6IkFULnRzRXE4NFFXVFNGOEk1VzVaaFJmWUsyVU1odWRhX2hGRUw5VENiSWVGdDAiLCJpc3MiOiJodHRwczovL2Rldi04ODQyNTQub2t0YXByZXZpZXcuY29tL29hdXRoMi9kZWZhdWx0IiwiYXVkIjoiYXBpOi8vZGVmYXVsdCIsImlhdCI6MTY3NDg0NDM4MCwiZXhwIjoxNjc0ODQ3OTgwLCJjaWQiOiIwb2FlZzN5Z2hhTDltUWFsejBoNyIsInVpZCI6IjAwdWVnYzA2b3pnajEya2xlMGg3Iiwic2NwIjpbInByb2ZpbGUiLCJlbWFpbCIsIm9wZW5pZCJdLCJhdXRoX3RpbWUiOjE2NzQ4NDQzNzksInN1YiI6ImthcmltQGV4YWthLmNvbSIsImdyb3VwcyI6WyJtYW5hZ2VyIl0sImxvY2FsZSI6ImZyX0ZSIn0.Nrqref-qr4_CzQfvbTz8lYy7IX7o2Evpv9SQ6TuCiTP5pIJIYiubSNuks6l7SCA9K1bCsD62vyRe0dTPHMLMfEafFEPKyD-P04-yMVE_X1X1fa5OU4oQPiYrCKPYTnvti5vhn4SEVkaUZAZyvtHvfF3c33xhDII9Uix7CA4vshWiY7Z_Lkw6egE4SS1U5rKQewy7wlL-EQJBzi5mcLA37lWkAh4uS6k1vGU4BMetCwdQOkLLgKSMZ1H57tHawFIi02b4YFwEfoj9vlEsK_3SRAMZku9caMCQceS7GgvkX6idi6Sbgq_mtLA7Xqt79JX_t57iP20wSq5k1Th7hXKI0g"
const wait  = 1
const url   = "http://stationback.exakaconsulting.org/StationDemoSecureWeb/station/stations"

const params = {
    headers: {
      'Content-Type': 'application/json',
      'Authorization' : "Bearer " + token
    },
  };

export default function () {
  const res = http.get(url, params);
  check(res, {
    'is status 200': (r) => r.status === 200,
  });
  sleep(wait);
}