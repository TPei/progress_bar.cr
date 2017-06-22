# Have a long running command? Keep your users updated on the progress
# by displaying a progress bar
#
# ```crystal
# require "progress_bar"
#
# # simple
# pb = ProgressBar.new
# pb.with_progress { pb.init; 10.times { sleep 0.1; pb.tick } }
# => [##########]
#
# # more control over stuff
# pb = ProgressBar.new(ticks: 100, chars: :funky, completion_message: "Installation done!")
# pb.with_progress do
#   pb.init
#   80.times { pb.tick; sleep 0.2 }
#   pb.progress by: 18
#   sleep 3 # that always happens!
#   pb.tick
#   pb.tick
# end
# => [████████████████████████████████████████████████████████████████████████████████████████████████████]
# => Installation done!
# ```
class ProgressBar
  CLEAR = STDOUT.tty? ? "\u001b[2K" : "\u000d"
  CHARS = {
    default: [" ", "#"],
    funky: ["▒", "█"],
  }

  # initializes the progress bar with necessary information:
  # `ticks = 10 # number of increments (bar size)`
  # `chars = :default # can also be :funky (what characters to use for bar)`
  # `completion_message: nil # string to display after loading is done`
	def initialize(@ticks = 10, @chars = :default, @completion_message : (Nil | String) = nil)
		@finished = false
		@count = 0
    @initiated = false
	end

  # yields and returns block return value
	def with_progress
		value = yield
		value
	end

  # initiate progressbar => print empty bar of specified length
  def init
    unless @initiated
      spawn do
				@initiated = true
				print "[#{CHARS[@chars][0] * @ticks}]\r"
      end
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

		spawn do
      if @count <= @ticks
				print "[#{CHARS[@chars][1] * @count}#{CHARS[@chars][0] * (@ticks - @count)}]\r"
      end
      if @count == @ticks && @completion_message
        puts "\n#{@completion_message}\n"
      end
		end
	end
end

class ProgressExceededException < Exception; end
