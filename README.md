# ProgressBar.cr

###### This project is being built weekly with the latest crystal version (works with v1.7.2 🎉)

![progress animation](https://github.com/tpei/progress_bar.cr/raw/master/demo.gif)

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
$ shards install
```

## Usage

```crystal
require "require "progress_bar.cr/progress_bar""

# simple
pb = ProgressBar.new
# print empty progress bar
pb.init
pb.message("Setting up now...")

10.times do
  sleep 0.1 # very time intense!
  pb.tick # increase bar progress by 1
end
# => Setting up now...
# => [##########]
```

### Block Usage

You can use the `with_progress` block to automatically reset and clean
up the progress bar after your block is done.
Block usage will also print the completion_message, even if you don't
completely fill the bar.

```crystal
pb = ProgressBar.new(completion_message: "DONE?")

pb.with_progress do
  pb.init

  5.times do
    sleep 0.1 # very time intense!
    pb.tick # increase bar progress by 1
  end
end
# => [########  ]
# => DONE?
```

###  Available Methods
```crystal
pb.init # prints empty bar
pb.tick: # increases bar filling by one and reprints
pb.message: # allows for printing progress messages
pb.progress(by: 10) # increases bar by desired number
pb.set(5) # set bar to given number
pb.set?(5) # try setting bar => true / false
pb.count # get current count
pb.reset # resets the progress bar to 0, without redrawing, making it
pb.complete # prints finish message, sets bar to max
reusable
```

## initialize options

- ticks: length the bar is made for. calling #tick more often raises an
  error (default is 10)
- show_percentage: true / false - whether or not to display the
  percentage next to the bar
- completion_message: message to be displayed after progress reaches
  100%
- charset / chars: characters to display for bar

### Characters

The bar basically consists of two different types of characters: one
signifying emptiness, one a filled state.

There are a number of different predefined char sets, that you can use:
- :default => [#####     ]
- :line    => [-----     ]
- :equals  => [=====     ]
- :bar     => [█████▒▒▒▒▒]

`ProgressBar.new(charset: :equals)`

You can also just hand in two characters of your own choosing:
`ProgressBar.new(chars: ["O", "X"] # => [XXXXX00000]`

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
