require 'dockerspec/serverspec'

describe docker_build("serverspec/.") do

  it { should have_maintainer(/Nan Liu/) }

  %w[DOCKER_VERSION DOCKER_SHA256].each do |e|
    it { should have_env e }
  end

  describe docker_run(described_image) do
    describe command('ruby --version') do
      its(:stdout) {
        should match %r(2\.4\.1)
      }
    end

    describe command('docker version') do
      its(:stdout) {
        should match %r(17\.03\.1)
      }
    end
  end
end
