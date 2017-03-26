class EventStore
  def load_events
    events = []

    Dir["data/events/*.yml"].each do |filename| 
      events << YAML.load_file(filename)
    end

    return events
  end
end