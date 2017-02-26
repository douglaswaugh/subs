require "spec_helper"

describe NoteLineSplitter do
  it("should split single line note to one line") do
    lines = NoteLineSplitter.split('13/01/2017 paid £3.50')
    expect(lines[0]).to eq "13/01/2017 paid £3.50"
  end

  it("should split multi-line note to multiple notes") do
    lines = NoteLineSplitter.split('13/01/2017 paid £3.50\n14/01/2017 c fee £5.38')
    expect(lines[0]).to eq "13/01/2017 paid £3.50"
    expect(lines[1]).to eq "14/01/2017 c fee £5.38"
  end
end