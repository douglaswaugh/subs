class NoteLineSplitter
  def self.split(lines)
    return lines.split('\n').reject { |line| line.empty? }
  end
end