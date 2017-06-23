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

# simple
pb = ProgressBar.new
# print empty progress bar
pb.init

10.times do
  sleep 0.1 # very time intense!
  pb.tick # increase bar progress by 1
end
# => [##########]
```

## block usage

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

## methods
```
pb.init # prints empty bar
pb.tick: # increases bar filling by one and reprints
pb.progress(by: 10) # increases bar by desired number
pb.reset # resets the progress bar to 0, without redrawing, making it
reusable
```

## initialize options

- ticks: length the bar is made for. calling #tick more often raises an
  error (default is 10)
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
