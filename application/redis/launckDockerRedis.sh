docker run -d \
  --name redis7 \
  -p 6379:6379 \
  -e REDIS_PASSWORD=test55 \
  redis:7 \
  redis-server --requirepass test55