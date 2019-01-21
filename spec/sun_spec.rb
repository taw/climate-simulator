describe Sun do
  let(:sun) { Sun.new }

  it "tilt" do
    expect(sun.tilt).to eq(23.45)
  end

  it "declination" do
    expect(sun.declination(0.00)).to eq(-23.45)
    expect(sun.declination(0.25)).to eq(  0.00)
    expect(sun.declination(0.50)).to eq(+23.45)
    expect(sun.declination(0.75)).to eq(  0.00)
  end
end
