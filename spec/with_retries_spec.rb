require "spec_helper"

describe PatientlyTry do
  it "has a version number" do
    expect(PatientlyTry::VERSION).not_to be nil
  end

  it "will retry" do
    tries = 0

    patiently_try logging: false do
      tries += 1
      raise StandardError if tries == 1
    end

    expect(tries).to eq 2
  end
end
