require "spec_helper"

describe NoteLineSplitter do
  it("should split single line note to one line") do
    lines = NoteLineSplitter.split('13/01/2017 paid £3.50')
    expect(lines[0]).to eq "13/01/2017 paid £3.50"
  end
end