Sentry.init do |config|
  config.dsn = 'https://17d51b59421a4da1a85efea8fe4b537f@o562124.ingest.sentry.io/5700279'
  config.breadcrumbs_logger = [:active_support_logger]

  # Set tracesSampleRate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production
  config.traces_sample_rate = 0.5
  # or
  config.traces_sampler = lambda do |context|
    true
  end
end
