# Have a long running command? Keep your users updated on the progress
# by displaying a progress bar
#
# ```crystal
# require "progress_bar"
#
# # simple
# pb = ProgressBar.new
# # print empty progress bar
# pb.init
#
# 10.times do
# sleep 0.1 # very time intense!
#   pb.tick # increase bar progress by 1
# end
# # => [##########]
# ```
class ProgressBar
  CHARSETS = {
    default: [" ", "#"],
    line: [" ", "-"],
    equals: [" ", "="],
    bar: ["▒", "█"]
  }

  # initializes the progress bar with necessary information:
  # `ticks = 10 # number of increments (bar size)`
  # `charset = :default # can also be :line, :equals, :bar (what characters to use for bar)`
  # `chars = [] # you can give two custom strings [empty_string, filled_string] to print instead of using a predefined charset`
  # `completion_message: nil # string to display after loading is done`
  # ProgressBar.new(chars: [" ", "x"])
	def initialize(@ticks = 10, @charset = :default, @chars = [] of String, @completion_message : (Nil | String) = nil)
		@count = 0
    @initiated = false
    @complete_printed = false
	end

  # yields and returns block return value
  # resetting the progress bar after completion
	def with_progress
		value = yield
    complete unless @complete_printed
    reset
		value
	end

  def complete 
    puts "\n#{@completion_message}\n"
  end

  # resetting the progress bar (emptying it)
  def reset
    @initiated = false
    @complete_printed = false
    @count = 0
  end

  # initiate progressbar => print empty bar of specified length
  def init
    unless @initiated
      @initiated = true
      print "[#{charset[0] * @ticks}]\r"
    end
  end

  # increment progress by one
	def tick
    @count += 1
    redraw
  end

  # progresses the bar by a specified amount
  def progress(by add = 1)
    @count += add
    redraw
  end

  private def redraw
		if @count > @ticks
			raise ProgressExceededException.new
    end

    if @count <= @ticks
      print "[#{charset[1] * @count}#{charset[0] * (@ticks - @count)}]\r"
    end
    if @count == @ticks && @completion_message
      complete unless @complete_printed
      @complete_printed = true
    end
	end

  private def charset
    if @charset == :default && @chars.size >= 2
      @chars[0..1]
    else
      CHARSETS[@charset]
    end
  rescue KeyError
    raise ProgressCharsetException.new("#{@charset} is not known!")
  end
end

class ProgressExceededException < Exception; end
class ProgressCharsetException < Exception; end
