require "with_retries/version"

module WithRetries
  def with_retries(opts = {})
    retries      = opts[:retries] || 100
    wait         = opts[:wait] || 0
    catch_errors = opts[:catch] || StandardError
    logging      = opts[:logging].nil? ? true : opts[:logging]
    try          = 0

    begin
      yield
    rescue catch_errors => e
      try += 1
      puts "Failed with: #{e.inspect}" if logging

      raise e if try >= retries

      puts "Retrying (#{try}/#{retries})"
      sleep wait if wait && wait > 0

      retry
    end
  end
end
