require 'progress_bar'

# Utility class that wraps `progress_bar` and listens to user cancelling events
class Task
  def initialize(total)
    JsCoach.info "Starting task..."

    progress = ProgressBar.new total
    yield progress

    JsCoach.success "Task finished."
  rescue SystemExit, Interrupt
    puts "See you soon!"
  end
end
