require 'spec_helper'

# rubocop:disable Metrics/BlockLength
describe 'ark::default' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(node_attributes)
    runner.converge(described_recipe)
  end

  shared_examples 'installs packages' do
    it 'installs necessary packages' do
      installed_packages.each do |name|
        expect(chef_run).to install_package(name)
      end
    end
  end

  context 'when no attributes are specified, on CentOS' do
    let(:node_attributes) do
      { platform: 'centos', version: '6.7' }
    end

    let(:installed_packages) do
      %w(libtool autoconf unzip rsync make gcc xz-lzma-compat bzip2 tar)
    end

    it_behaves_like "installs packages"

    it "does not install the gcc-c++ package" do
      expect(chef_run).not_to install_package("gcc-c++")
    end

    it "does not include the seven_zip recipe" do
      expect(chef_run).not_to include_recipe("seven_zip")
    end

    # Implementing a Helper Method
    let(:node) do
      chef_run.node
    end

    # Define method `attribute` to not repeating the task for node's attributes retrieval
    def attribute(name)
      node[described_cookbook][name]
    end

    it "apache mirror" do
      expect(attribute('apache_mirror')).to eq "http://apache.mirrors.tds.net"
    end

    it "prefix root" do
      attribute = chef_run.node['ark']['prefix_root']
      expect(attribute).to eq "/usr/local"
    end

    it "prefix bin" do
      attribute = chef_run.node['ark']['prefix_bin']
      expect(attribute).to eq "/usr/local/bin"
    end

    it "prefix home" do
      attribute = chef_run.node['ark']['prefix_home']
      expect(attribute).to eq "/usr/local"
    end

    it "tar binary" do
      attribute = chef_run.node['ark']['tar']
      expect(attribute).to eq "/bin/tar"
    end
  end

  context 'when no attributes are specified, on Debian' do
    let(:node_attributes) do
      { platform: 'ubuntu', platform_family: 'debian', version: '14.04' }
    end

    let(:installed_packages) do
      %w(libtool autoconf unzip rsync make gcc autogen shtool pkg-config)
    end

    it_behaves_like "installs packages"

    it "apache mirror" do
      attribute = chef_run.node['ark']['apache_mirror']
      expect(attribute).to eq "http://apache.mirrors.tds.net"
    end

    it "prefix root" do
      attribute = chef_run.node['ark']['prefix_root']
      expect(attribute).to eq "/usr/local"
    end

    it "prefix bin" do
      attribute = chef_run.node['ark']['prefix_bin']
      expect(attribute).to eq "/usr/local/bin"
    end

    it "prefix home" do
      attribute = chef_run.node['ark']['prefix_home']
      expect(attribute).to eq "/usr/local"
    end

    it "tar binary" do
      attribute = chef_run.node['ark']['tar']
      expect(attribute).to eq "/bin/tar"
    end
  end
end
