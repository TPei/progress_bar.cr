require "spec"
require "../src/progress_bar"

describe ProgressBar do
  it "returns the block return" do
    ProgressBar.new.with_progress { 1 }.should eq 1
  end
end
