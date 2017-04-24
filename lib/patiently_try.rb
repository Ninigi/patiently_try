require "patiently_try/version"

module PatientlyTry
  def patiently_try(opts = {})
    retries      = opts[:retries] || 100
    wait         = opts[:wait] || 0
    catch_errors = opts[:catch] || StandardError
    logging      = opts[:logging].nil? ? true : opts[:logging]
    try          = 0

    begin
      yield
    rescue *(Array(catch_errors)) => e
      puts "Failed (#{try}/#{retries}) with: #{e.inspect}" if logging
      try += 1

      raise e if try >= retries

      puts "Retrying (#{try}/#{retries})" if logging
      sleep wait if wait && wait > 0

      retry
    end
  end
end
