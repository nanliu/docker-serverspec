require 'rspec/retry'
require 'dockerspec/serverspec'

describe docker_build("/serverspec/snap/.") do
  it { should have_maintainer /Nan Liu/ }

  %w[SNAP_VERSION SNAP_TRUST_LEVEL SNAP_LOG_LEVEL].each do |e|
    it { should have_env e }
  end

  { "vendor" => "Intelsdi-X",
    "license" => "Apache 2.0",
    "build-date" => "",
    "io.snap-telemetry.snap.version.is-beta" => "", 
  }.each do |k, v|
    it { should have_label( k => v ) }
  end

  it { should have_expose '8181' }
  it { should have_cmd ["/bin/sh", "-c", "/usr/local/bin/init_snap && /opt/snap/sbin/snapteld -t ${SNAP_TRUST_LEVEL} -l ${SNAP_LOG_LEVEL} -o ''"] }

  describe docker_run(described_image) do
    describe command('/usr/local/bin/init_snap') do
      its(:exit_status) { should eq 0 }
    end

    bins = [
      "/opt/snap/bin/snaptel",
      "/opt/snap/sbin/snapteld",
      "/usr/local/bin/init_snap",
    ]

    bins.each do |f|
      describe file(f) do
        it { should be_file }
        it { should be_executable }
      end
    end

    symlinks = {
      "/usr/local/sbin/snapteld" => "/opt/snap/sbin/snapteld",
      "/usr/local/bin/snaptel" => "/opt/snap/bin/snaptel",
    }
    symlinks.each do |f, t|
      describe file(f) do
        it { should be_symlink }
        it { should be_linked_to t }
      end
    end

    # This can be removed after test have been migrated to the new binaries
    snapd = {
      "/usr/local/sbin/snapd" => "/opt/snap/sbin/snapteld",
      "/usr/local/bin/snapctl" => "/opt/snap/bin/snaptel",
      "/etc/snap/snapd.conf" => "/etc/snap/snapteld.conf",
    }
    snapd.each do |f, t|
      describe file(f) do
        it { should be_symlink }
        it { should be_linked_to t }
      end
    end

    folders = [
      "/opt/snap/bin",
      "/opt/snap/plugins",
      "/var/log/snap",
      "/etc/snap",
    ]

    folders.each do |f|
      describe file(f) do
        it { should be_directory }
      end
    end

    describe file('/etc/snap/snapteld.conf') do
      it { should be_file }
      its(:content_as_yaml) {
        should include('log_path' => '/var/log/snap')
        should include('control' => {
          "auto_discover_path" => "/opt/snap/plugins",
          "plugin_trust_level" => 0,
        })
      }
    end

    describe command('/opt/snap/sbin/snapteld --version') do
      its(:stdout) { should match /snapteld version/ }
    end

    describe command('/opt/snap/bin/snaptel --version'),:retry => 3, :retry_wait => 10 do
      its(:stdout) { should match /snaptel version/ }
    end
  end
end
