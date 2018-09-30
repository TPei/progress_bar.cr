require "./src/progress_bar"

pb = ProgressBar.new(ticks: 40, charset: :bar, completion_message: "Installation finished", show_percentage: true)

pb.with_progress do
  pb.init

  pb.message "Setting up repo..."

  sleep 1.5

  pb.tick

  pb.message "Loading dependencies..."

  sleep 1.5

  pb.tick

  35.times do |i|
    pb.message "Installation step #{i+1}/35..."
    sleep 0.05
    pb.tick
  end

  pb.message "Configuring database..."

  pb.tick

  sleep 1

  pb.message "Moving files..."

  pb.tick

  pb.message "Cleaning up..."

  sleep 1.5

  pb.tick
end
