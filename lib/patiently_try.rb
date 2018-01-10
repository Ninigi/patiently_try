require "patiently_try/version"

module PatientlyTry
  def patiently_try(opts = {})
    opts = _parse_opts(opts)
    try  = 0

    begin
      yield
    rescue *(opts[:catch]) => e
      try += 1

      _rescue_or_raise(e, try, opts)

      _wait(opts[:wait])
      retry
    end
  end

  private

  def _rescue_or_raise(e, try, opts)
    if opts[:logging]
      _rescue_or_raise_with_logging(e, try, opts)
    else
      _rescue_or_raise_without_logging(e, try, opts)
    end
  end

  def _rescue_or_raise_with_logging(e, try, opts)
    _log_error(e) if opts[:logging]

    if _should_raise?(e, try, opts)
      _log_backtrace(e) if opts[:logging]
      raise e
    end

    _log_retry(e) if opts[:logging]
  end

  def _rescue_or_raise_without_logging(e, try, opts)
    raise e if _should_raise?(e, try, opts)
  end

  def _should_raise?(e, try, opts)
    _exceeded_retries?(try, opts[:retries]) || _rescued_but_excluded?(e, opts[:raise_if_caught])
  end

  def _parse_opts(opts)
    {
      catch:           Array(opts[:catch] || StandardError),
      raise_if_caught: Array(opts[:raise_if_caught]),
      wait:            opts[:wait].to_i,
      logging:         opts[:logging].nil? ? true : opts[:logging],
      retries:         opts[:retries] || 100
    }
  end

  def _wait(wait_time)
    sleep wait_time if wait_time > 0
  end

  def _exceeded_retries?(try, retries)
    try >= retries
  end

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
