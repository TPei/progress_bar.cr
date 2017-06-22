# ProgressBar.cr

## Installation

Add to your shard.yml

```yaml
dependencies:
  progress_bar.cr:
    github: tpei/progress_bar.cr
    branch: master
```

and then install the library into your project with

```bash
$ crystal deps
```

## Usage

```crystal
require "progress_bar"

# create a new progress bar to your liking

# simple
pb = ProgressBar.new
pb.with_progress { pb.init; 10.times { sleep 0.1; pb.tick } }
# => [##########]

# more control over stuff
pb = ProgressBar.new(ticks: 100, chars: :funky, completion_message: "Installation done!")

r = Random.new

# give a block that performs your time-intense task
pb.with_progress do
  # print empty bar
  pb.init

  sleep r.rand(0.3) # heavy computation going on here!!
  80.times do
		sleep r.rand(0.3)
    # increment the bar
    pb.tick
  end

  sleep 0.1
  # progress the bar by an amount of your choice
  pb.progress by: 5

  sleep 0.2
  pb.progress by: 7

  sleep 0.2
  pb.progress by: 4

  4.times do
    sleep 0.1
    pb.tick
  end
end

sleep 0.1
```

## Errors

Don't exceed the tick number, will throw an exception!

```crystal
# count already == ticks
begin
  pb.tick # => (ProgressExceededException)
rescue
  puts "Sorry, installation taking longer than expected"
end

sleep 0.1
```
