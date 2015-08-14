require 'spec_helper'
require 'rubygems'
require 'fileutils'

  describe Jettywrapper do

    # JETTY1 =
    before(:all) do
      @jetty_params = {
        :quiet => false,
        :jetty_home => "/path/to/jetty",
        :jetty_port => TEST_JETTY_PORTS.first,
        :solr_home => "/path/to/solr",
        :startup_wait => 0,
        :java_opts => ["-Xmx256m"],
        :jetty_opts => ["/path/to/jetty_xml", "/path/to/other_jetty_xml"]
      }

      Jettywrapper.logger.level=3
    end

    before do
      Jettywrapper.reset_config
      FileUtils.rm "tmp/master.zip", force: true
    end

    context "downloading" do
      context "with default file" do
        it "should download the zip file" do
          expect(Jettywrapper).to receive(:open).with('https://github.com/projecthydra/hydra-jetty/archive/master.zip').and_return(system ('true'))
          Jettywrapper.download
        end
      end

      context "specifying the file" do
        it "should download the zip file" do
          expect(Jettywrapper).to receive(:open).with('http://example.co/file.zip').and_return(system ('true'))
          Jettywrapper.download('http://example.co/file.zip')
          expect(Jettywrapper.url).to eq('http://example.co/file.zip')
        end
      end
      context "specifying the version" do
        it "should download the zip file" do
          expect(Jettywrapper).to receive(:open).with('https://github.com/projecthydra/hydra-jetty/archive/v9.9.9.zip').and_return(system ('true'))
          Jettywrapper.hydra_jetty_version = 'v9.9.9'
          Jettywrapper.download
        end
      end
    end

    context "unzip" do
      before do
        Jettywrapper.url = nil
      end
      context "with default file" do
        it "should download the zip file" do
          expect(File).to receive(:exists?).and_return(true)
          expect(Jettywrapper).to receive(:expanded_zip_dir).and_return('tmp/jetty_generator/interal_dir')
          expect(Zip::File).to receive(:open).with('tmp/master.zip').and_return(true)
          expect(FileUtils).to receive(:remove_dir).with('jetty',true).and_return(true)
          expect(FileUtils).to receive(:mv).with('tmp/jetty_generator/interal_dir','jetty').and_return(true)
          Jettywrapper.unzip
        end
      end

      context "specifying the file" do
        before do
          Jettywrapper.url = 'http://example.co/file.zip'
        end
        it "should download the zip file" do
          expect(File).to receive(:exists?).and_return(true)
          expect(Jettywrapper).to receive(:expanded_zip_dir).and_return('tmp/jetty_generator/interal_dir')
          expect(Zip::File).to receive(:open).with('tmp/file.zip').and_return(true)
          expect(FileUtils).to receive(:remove_dir).with('jetty',true).and_return(true)
          expect(FileUtils).to receive(:mv).with('tmp/jetty_generator/interal_dir','jetty').and_return(true)
          Jettywrapper.unzip
        end
      end
    end

    context ".url" do
      before do
        subject.url = nil
      end
      subject {Jettywrapper}
      context "When a constant is set" do
        before do
          ZIP_URL = 'http://example.com/foo.zip'
        end
        after do
          Object.send(:remove_const, :ZIP_URL)
        end
        its(:url) {should == 'http://example.com/foo.zip'}
      end
      context "when a url is set" do
        before do
          subject.url = 'http://example.com/bar.zip'
        end
        its(:url) {should == 'http://example.com/bar.zip'}
      end
      context "when url is not set" do
        its(:url) {should == 'https://github.com/projecthydra/hydra-jetty/archive/master.zip'}
      end
    end

    context ".tmp_dir" do
      subject {Jettywrapper}
      context "when a dir is set" do
        before do
          subject.tmp_dir = '/opt/tmp'
        end
        its(:tmp_dir) {should == '/opt/tmp'}
      end
      context "when dir is not set" do
        before do
          subject.tmp_dir = nil
        end
        its(:tmp_dir) {should == 'tmp'}
      end

    end

    context ".jetty_dir" do
      subject {Jettywrapper}
      context "when a dir is set" do
        before do
          subject.jetty_dir = '/opt/jetty'
        end
        its(:jetty_dir) {should == '/opt/jetty'}
      end
      context "when dir is not set" do
        before do
          subject.jetty_dir = nil
        end
        its(:jetty_dir) {should == 'jetty'}
      end
    end

    context "app_root" do
      subject {Jettywrapper}
      context "When rails is present" do
        before do
          class Rails
            def self.root
              'rails_root'
            end
          end
        end
        after do
          Object.send(:remove_const, :Rails)
        end
        its(:app_root) {should == 'rails_root'}
      end
      context "When APP_ROOT is set" do
        before do
          APP_ROOT = 'custom_root'
        end
        after do
          Object.send(:remove_const, :APP_ROOT)
        end
        its(:app_root) {should == 'custom_root'}
      end
      context "otherwise" do
        its(:app_root) {should == '.'}
      end
    end

    describe "env" do
      before do
        ENV.delete('JETTYWRAPPER_ENV')
        ENV.delete('RAILS_ENV')
        ENV.delete('environment')
      end

      it "should have a setter" do
        Jettywrapper.env = "abc"
        expect(Jettywrapper.env).to eq "abc"
      end

      it "should load the ENV['JETTYWRAPPER_ENV']" do
        ENV['JETTYWRAPPER_ENV'] = 'test'
        ENV['RAILS_ENV'] = 'test2'
        ENV['environment'] = 'test3'
        expect(Jettywrapper.env).to eq "test"
      end

      it "should be the Rails environment" do
        Rails = double(env: 'test')
        expect(Jettywrapper.env).to eq "test"
        Rails = nil
      end

      it "should use the ENV['RAILS_ENV']" do
        ENV['RAILS_ENV'] = 'test2'
        ENV['environment'] = 'test3'
        expect(Jettywrapper.env).to eq "test2"
      end

      it "should load the ENV['environment']" do
        ENV['environment'] = 'test3'
        expect(Jettywrapper.env).to eq "test3"
      end

      it "should default to 'development'" do
        expect(Jettywrapper.env).to eq "development"
      end

    end

    context "config" do
      before do
      end
      it "loads the application jetty.yml first" do
        expect(IO).to receive(:read).with('./config/jetty.yml').and_return("default:\n")
        config = Jettywrapper.load_config
      end

      it "loads the application jetty.yml using erb parsing" do
        expect(IO).to receive(:read).with('./config/jetty.yml').and_return("default:\n  a: <%= 123 %>")
        config = Jettywrapper.load_config
        config[:a] == 123
      end

      it "falls back on the distributed jetty.yml" do
        expect(File).to receive(:exists?).with('./config/jetty.yml').and_return(false)
        expect(IO).to receive(:read).with(/jetty.yml/).and_return("default:\n")
        config = Jettywrapper.load_config
      end

      it "supports per-environment configuration" do
        ENV['environment'] = 'test'
        expect(IO).to receive(:read).with('./config/jetty.yml').and_return("default:\n  a: 1\ntest:\n  a: 2")
        config = Jettywrapper.load_config
        expect(config[:a]).to eq(2)
      end

      it "should take the env as an argument to load_config and the env should be sticky" do
        expect(IO).to receive(:read).with('./config/jetty.yml').and_return("default:\n  a: 1\nfoo:\n  a: 2")
        config = Jettywrapper.load_config('foo')
        expect(config[:a]).to eq(2)
        expect(Jettywrapper.env).to eq 'foo'
      end

      it "falls back on a 'default' environment configuration" do
        ENV['environment'] = 'test'
        expect(IO).to receive(:read).with('./config/jetty.yml').and_return("default:\n  a: 1")
        config = Jettywrapper.load_config
        expect(config[:a]).to eq(1)
      end
    end

    context "instantiation" do
      it "can be instantiated" do
        ts = Jettywrapper.instance
        expect(ts.class).to eql(Jettywrapper)
      end

      it "can be configured with a params hash" do
        ts = Jettywrapper.configure(@jetty_params)
        expect(ts.quiet).to eq(false)
        expect(ts.jetty_home).to eq("/path/to/jetty")
        expect(ts.port).to eq(@jetty_params[:jetty_port])
        expect(ts.solr_home).to eq('/path/to/solr')
        expect(ts.startup_wait).to eq(0)
        expect(ts.jetty_opts).to eq(@jetty_params[:jetty_opts])
      end

      it "should override nil params with defaults" do
        jetty_params = {
          :quiet => nil,
          :jetty_home => '/path/to/jetty',
          :jetty_port => nil,
          :solr_home => nil,
          :startup_wait => nil,
          :jetty_opts => nil
        }

        ts = Jettywrapper.configure(jetty_params)
        expect(ts.quiet).to eq(true)
        expect(ts.jetty_home).to eq("/path/to/jetty")
        expect(ts.port).to eq(8888)
        expect(ts.solr_home).to eq(File.join(ts.jetty_home, "solr"))
        expect(ts.startup_wait).to eq(5)
        expect(ts.jetty_opts).to eq([])
      end

      it "passes all the expected values to jetty during startup" do
        ts = Jettywrapper.configure(@jetty_params)
        command = ts.jetty_command
        expect(command).to include("-Dsolr.solr.home=#{@jetty_params[:solr_home]}")
        expect(command).to include("-Djetty.port=#{@jetty_params[:jetty_port]}")
        expect(command).to include("-Xmx256m")
        expect(command).to include("start.jar")
        expect(command.slice(command.index('start.jar')+1, 2)).to eq(@jetty_params[:jetty_opts])
      end

      it "escapes the :solr_home parameter" do
        ts = Jettywrapper.configure(@jetty_params.merge(:solr_home => '/path with spaces/to/solr'))
        command = ts.jetty_command
        expect(command).to include("-Dsolr.solr.home=/path\\ with\\ spaces/to/solr")
      end

      it "has a pid if it has been started" do
        jetty_params = {
          :jetty_home => '/tmp'
        }
        ts = Jettywrapper.configure(jetty_params)
        allow_any_instance_of(Jettywrapper).to receive(:process).and_return(double('proc', :start => nil, :pid=>5454))
        ts.stop
        ts.start
        expect(ts.pid).to eql(5454)
        ts.stop
      end

      it "can pass params to a start method" do
        jetty_params = {
          :jetty_home => '/tmp', :jetty_port => 8777
        }
        ts = Jettywrapper.configure(jetty_params)
        ts.stop
        allow_any_instance_of(Jettywrapper).to receive(:process).and_return(double('proc', :start => nil, :pid=>2323))
        swp = Jettywrapper.start(jetty_params)
        expect(swp.pid).to eql(2323)
        expect(swp.pid_file).to eql("_tmp_test.pid")
        swp.stop
      end

      it "can get the status for a given jetty instance" do
        # Don't actually start jetty, just fake it
        allow_any_instance_of(Jettywrapper).to receive(:process).and_return(double('proc', :start => nil, :pid=>12345))

        jetty_params = {
          :jetty_home => File.expand_path("#{File.dirname(__FILE__)}/../../jetty")
        }
        Jettywrapper.stop(jetty_params)
        expect(Jettywrapper.is_jetty_running?(jetty_params)).to eql(false)
        Jettywrapper.start(jetty_params)
        expect(Jettywrapper.is_jetty_running?(jetty_params)).to eql(true)
        Jettywrapper.stop(jetty_params)
      end

      it "can get the pid for a given jetty instance" do
        # Don't actually start jetty, just fake it
        allow_any_instance_of(Jettywrapper).to receive(:process).and_return(double('proc', :start => nil, :pid=>54321))
        jetty_params = {
          :jetty_home => File.expand_path("#{File.dirname(__FILE__)}/../../jetty")
        }
        Jettywrapper.stop(jetty_params)
        expect(Jettywrapper.pid(jetty_params)).to eql(nil)
        Jettywrapper.start(jetty_params)
        expect(Jettywrapper.pid(jetty_params)).to eql(54321)
        Jettywrapper.stop(jetty_params)
      end

      it "can pass params to a stop method" do
        jetty_params = {
          :jetty_home => '/tmp', :jetty_port => 8777
        }
        allow_any_instance_of(Jettywrapper).to receive(:process).and_return(double('proc', :start => nil, :pid=>2323))
        swp = Jettywrapper.start(jetty_params)
        expect(File.file? swp.pid_path).to eql(true)

        swp = Jettywrapper.stop(jetty_params)
        expect(File.file? swp.pid_path).to eql(false)
      end

      describe "creates a pid file" do
        let(:ts) { Jettywrapper.configure(@jetty_params) }
        describe "when the environment isn't set" do
          before { ENV['environment'] = nil }
          it "should have the path and env in the name" do
            expect(ts.pid_file).to eql("_path_to_jetty_development.pid")
          end
        end
        describe "when the environment is set" do
          before { ENV['environment'] = 'test' }
          it "should have the path and env in the name" do
            expect(ts.pid_file).to eql("_path_to_jetty_test.pid")
          end
        end
      end

      it "knows where its pid file should be written" do
        ts = Jettywrapper.configure(@jetty_params)
        expect(ts.pid_dir).to eql(File.expand_path("#{ts.base_path}/tmp/pids"))
      end

      it "writes a pid to a file when it is started" do
        jetty_params = {
          :jetty_home => '/tmp'
        }
        ts = Jettywrapper.configure(jetty_params)
        allow_any_instance_of(Jettywrapper).to receive(:process).and_return(double('proc', :start => nil, :pid=>2222))
        ts.stop
        expect(ts.pid_file?).to eql(false)
        ts.start
        expect(ts.pid).to eql(2222)
        expect(ts.pid_file?).to eql(true)
        pid_from_file = File.open( ts.pid_path ) { |f| f.gets.to_i }
        expect(pid_from_file).to eql(2222)
      end

    end # end of instantiation context

    context "logging" do
      it "has a logger" do
        ts = Jettywrapper.configure(@jetty_params)
        expect(ts.logger).to be_kind_of(Logger)
      end

    end # end of logging context

    context "wrapping a task" do
      it "wraps another method" do
        allow_any_instance_of(Jettywrapper).to receive(:start).and_return(true)
        allow_any_instance_of(Jettywrapper).to receive(:stop).and_return(true)
        error = Jettywrapper.wrap(@jetty_params) do
        end
        expect(error).to eql(false)
      end

      it "configures itself correctly when invoked via the wrap method" do
        allow_any_instance_of(Jettywrapper).to receive(:start).and_return(true)
        allow_any_instance_of(Jettywrapper).to receive(:stop).and_return(true)
        error = Jettywrapper.wrap(@jetty_params) do
          ts = Jettywrapper.instance
          expect(ts.quiet).to eq(@jetty_params[:quiet])
          expect(ts.jetty_home).to eq("/path/to/jetty")
          expect(ts.port).to eq(@jetty_params[:jetty_port])
          expect(ts.solr_home).to eq("/path/to/solr")
          expect(ts.startup_wait).to eq(0)
        end
        expect(error).to eql(false)
      end

      it "captures any errors produced" do
        allow_any_instance_of(Jettywrapper).to receive(:start).and_return(true)
        allow_any_instance_of(Jettywrapper).to receive(:stop).and_return(true)
        expect(Jettywrapper.instance.logger).to receive(:error).with("*** Error starting jetty: this is an expected error message")
        expect { error = Jettywrapper.wrap(@jetty_params) do
          raise "this is an expected error message"
        end }.to raise_error "this is an expected error message"
      end

    end # end of wrapping context

    context "quiet mode", :quiet => true do
      it "inherits the current stderr/stdout in 'loud' mode" do
        ts = Jettywrapper.configure(@jetty_params.merge(:quiet => false))
        process = ts.process
        expect(process.io.stderr).to eq($stderr)
        expect(process.io.stdout).to eq($stdout)
      end

      it "redirect stderr/stdout to a log file in quiet mode" do
        ts = Jettywrapper.configure(@jetty_params.merge(:quiet => true))
        process = ts.process
        expect(process.io.stderr).not_to eq($stderr)
        expect(process.io.stdout).not_to eq($stdout)
      end
    end
  end
