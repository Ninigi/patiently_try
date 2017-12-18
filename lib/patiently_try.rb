require "patiently_try/version"

module PatientlyTry
  def patiently_try(opts = {})
    retries         = opts[:retries] || 100
    wait            = opts[:wait] || 0
    catch_errors    = Array(opts[:catch] || StandardError)
    excluded_errors = Array(opts[:raise_if_caught])
    logging         = opts[:logging].nil? ? true : opts[:logging]
    try             = 0

    begin
      yield
    rescue *(catch_errors) => e
      try += 1

      _log_error(e) if logging

      if try >= retries || _rescued_but_excluded?(e, excluded_errors)
        _log_backtrace(e) if logging
        raise e
      end

      _log_retry(e) if logging

      sleep wait if wait && wait > 0

      retry
    end
  end

  private

  def _log_retry
    puts "Retrying (#{try}/#{retries})"
  end

  def _rescued_but_excluded?(e, excluded_errors)
    excluded_errors.to_a.inject(false) { |excl, error| excl || e.is_a?(error) }
  end

  def _log_error(e)
    puts "Failed with: #{e.inspect}"
  end

  def _log_backtrace(e)
    puts e.backtrace.join("\n")
  end
end
