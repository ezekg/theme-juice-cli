describe ThemeJuice::Tasks::VMBox do

  before do
    @env = ThemeJuice::Env

    allow(@env).to receive(:vm_path).and_return File.expand_path("~/tj-vagrant-test")
    allow(@env).to receive(:vm_box).and_return "git@github.com:some/vagrant/box.git"
    allow(@env).to receive(:verbose).and_return true
    allow(@env).to receive(:dryrun).and_return true
  end

  before :each do
    @task    = ThemeJuice::Tasks::VMBox.new
    @vm_path = @env.vm_path.gsub /\//, "." # Thor formats `/` (delimiter) as `.`
  end

  describe "#execute" do

    context "when a vagrant box is not detected" do

      it "should clone vagrant box to vm path" do
        output = capture(:stdout) { @task.execute }

        expect(output).to match /git clone/
        expect(output).to match /#{@env.vm_box}/
        expect(output).to match /#{@vm_path}/
      end
    end

    context "when Env.vm_revision is nil" do

      before do
        allow(@env).to receive(:vm_revision).and_return nil
      end

      it "should clone the master branch of the vm box repository" do
        output = capture(:stdout) { @task.execute }

        expect(output).to match /git clone/
        expect(output).to_not match /git checkout/
        expect(output).to match /#{@env.vm_box}/
      end
    end

    context "when Env.vm_revision is not nil" do

      before do
        allow(@env).to receive(:vm_revision).and_return "sha1-rev"
      end

      it "should clone the master branch of the vm box repository" do
        output = capture(:stdout) { @task.execute }

        expect(output).to match /git clone/
        expect(output).to match /git checkout sha1-rev/
        expect(output).to match /#{@env.vm_box}/
      end
    end

    context "when a vagrant box is detected" do

      before do
        FileUtils.mkdir_p "#{@env.vm_path}"
        FileUtils.touch "#{@env.vm_path}/Vagrantfile"
      end

      it "should not clone vagrant box to vm path" do
        output = capture(:stdout) { @task.execute }

        expect(output).to_not match /git clone/
        expect(output).to_not match /#{@env.vm_box}/
        expect(output).to_not match /#{@vm_path}/
      end
    end
  end
end
