require "spec_helper"

describe PatientlyTry do
  it "has a version number" do
    expect(PatientlyTry::VERSION).not_to be nil
  end

  it "should retry" do
    tries = 0

    patiently_try logging: false do
      tries += 1
      raise StandardError if tries == 1
    end

    expect(tries).to be 2
  end

  context "when opts[:retries]" do
    it "should only retry the specified number of times" do
      tries = 0

      begin
        patiently_try logging: false, retries: 1 do
          tries += 1
          raise StandardError
        end
      rescue; end

      expect(tries).to be 1
    end
  end

  context "when opts[:catch]" do
    it "should only rescue specified errors" do
      caught_proc = proc do
        tries = 0
        patiently_try logging: false, catch: ArgumentError do
          tries += 1
          raise ArgumentError if tries == 1
        end
      end

      uncaught_proc = proc do
        tries = 0
        patiently_try logging: false, catch: ArgumentError do
          tries += 1
          raise NoMethodError if tries == 1
        end
      end

      expect(caught_proc).not_to raise_error
      expect(uncaught_proc).to raise_error(NoMethodError)
    end
  end

  context "when opts[:raise_if_caught]" do
    it "should not rescue from those errors" do
      uncaught_proc = proc do
        tries = 0
        patiently_try logging: false, raise_if_caught: ArgumentError do
          tries += 1
          raise ArgumentError if tries == 1
        end
      end

      expect(uncaught_proc).to raise_error(ArgumentError)
    end
  end
end
