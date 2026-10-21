# $prod isn't defined yet when Puma reads this file (the app loads later), so check the env directly.
USE_PUMA_WORKERS = (ENV['RACK_ENV'] == 'production')

if USE_PUMA_WORKERS
  workers Integer(ENV['WEB_CONCURRENCY'] || 1)

  threads_count = Integer(ENV['MAX_THREADS'] || 1)
  threads threads_count, threads_count

  preload_app!

  # The Mongo driver is not fork-safe: with preload_app! the client (and its
  # server-monitor threads) is created in the master, and threads don't survive
  # fork. Without this the worker's topology freezes, and the first Atlas
  # failover leaves it stuck on "No primary server is available" until restart.
  before_worker_boot { $mongo&.reconnect }

  port        ENV['PORT']     || 9393
  environment ENV['RACK_ENV'] || 'development'
end
