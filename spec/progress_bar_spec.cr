require "spec"
require "../src/progress_bar"

describe ProgressBar do
  it "returns the block return" do
    ProgressBar.new.with_progress { 1 }.should eq 1
  end

  context "with block given" do
    it "resets after block completion" do
      pb = ProgressBar.new(chars: ["O", "X"])
      pb.with_progress do
        pb.init

        10.times do
          pb.tick
        end
      end

      pb.init
      5.times do
        pb.tick
      end

      pb.progress(by: 5)
    end
  end

  context "with too many ticks" do
    it "raises a ProgressExceededException" do
      pb = ProgressBar.new(chars: ["O", "X"])
      pb.init

      5.times do
        pb.tick
      end

      pb.progress(by: 5)

      expect_raises(ProgressExceededException) { pb.tick }
    end
  end

  context "with all those init arguments" do
    it "doesn't throw an error" do
      pb = ProgressBar.new(ticks: 100, charset: :bar, chars: ["X", "O"], completion_message: "Done")
      pb.init
      pb.tick
    end
  end

  context "with a non_existing charset" do
    it "raises a " do
      expect_raises(ProgressCharsetException, "nope is not known!") do
        pb = ProgressBar.new(charset: :nope)
        pb.tick
      end
    end
  end

  context "with too little chars" do
    it "doesn't raise an error" do
      pb = ProgressBar.new(chars: ["only one"])
      pb.tick
    end
  end

  describe "#count" do
    it "returns the current level" do
      pb = ProgressBar.new
      pb.tick
      pb.tick
      pb.count.should eq 2
    end
  end

  describe "#tick" do
    it "increments the count" do
      pb = ProgressBar.new
      pb.tick
      pb.tick
      pb.count.should eq 2
    end

    it "returns the new count" do
      pb = ProgressBar.new
      pb.tick
      pb.tick.should eq 2
    end
  end

  describe "#complete" do
    it "sets count to max" do
      pb = ProgressBar.new
      pb.complete
      pb.count.should eq 10
    end
  end

  describe "#reset"  do
    it "sets count to 0" do
      pb = ProgressBar.new
      pb.tick
      pb.reset
      pb.count.should eq 0
    end
  end

  describe "#set" do
    context "with valid value" do
      it "sets the new value" do
        pb = ProgressBar.new
        pb.set 9
        pb.count.should eq 9
      end
    end

    context "with too large a value" do
      it "throws a ProgressExceededException" do
        pb = ProgressBar.new
        pb.set(9)
        pb.count.should eq 9
        expect_raises(ProgressExceededException) do
          pb.set(11)
        end
      end
    end
  end

  describe "#set?" do
    context "with valid value" do
      it "sets the new value" do
        pb = ProgressBar.new
        pb.set?(9).should eq true
        pb.count.should eq 9
      end
    end

    context "with too large a value" do
      it "doesn't set the value" do
        pb = ProgressBar.new
        pb.set?(9).should eq true
        pb.set?(11).should eq false
        pb.count.should eq 9
      end
    end
  end
end
