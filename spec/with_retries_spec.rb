require "spec_helper"

describe WithRetries do
  it "has a version number" do
    expect(WithRetries::VERSION).not_to be nil
  end

  it "will retry" do
    tries = 0

    with_retries logging: false do
      tries += 1
      raise StandardError if tries == 1
    end

    expect(tries).to eq 2
  end
end
