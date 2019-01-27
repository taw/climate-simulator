describe Sun do
  let(:sun) { Sun.new }
  let(:tilt) { 23.45 }

  it "#tilt" do
    expect(sun.tilt).to eq(tilt)
  end

  it "#declination" do
    expect(sun.declination(0.00)).to eq(-23.45)
    expect(sun.declination(0.25)).to eq(  0.00)
    expect(sun.declination(0.50)).to eq(+23.45)
    expect(sun.declination(0.75)).to eq(  0.00)

    expect(sun.declination(8.50)).to eq(+23.45)
  end

  it "#hour_angle" do
    expect(sun.hour_angle( 0)).to eq(-180)
    expect(sun.hour_angle( 1)).to eq(-165)
    expect(sun.hour_angle(12)).to eq(   0)
    expect(sun.hour_angle(23)).to eq( 165)
    expect(sun.hour_angle(24)).to eq(-180)
    expect(sun.hour_angle(-2)).to eq( 150)
    expect(sun.hour_angle(50)).to eq(-150)
  end

  # Tests here are a bit bad...

  it "#altitude" do
    expect(sun.altitude(-tilt,0.00, 12)).to eq(90)
    expect(sun.altitude(   0, 0.25, 12)).to eq(90)
    expect(sun.altitude(tilt, 0.50, 12)).to eq(90)
    expect(sun.altitude(   0, 0.75, 12)).to eq(90)
  end

  it "#radiation" do
    expect(sun.radiation(-tilt,0.00, 12)).to eq(1)
    expect(sun.radiation(   0, 0.25, 12)).to eq(1)
    expect(sun.radiation(tilt, 0.50, 12)).to eq(1)
    expect(sun.radiation(   0, 0.75, 12)).to eq(1)
  end

  it "#daily_radation" do
    expect(sun.daily_radiation(0, 0.25)).to eq(0.31649)
  end

  # C <-> K
  it "emissions" do
    expect(Sun.emissions(30)).to eq(0.31649)
  end

  it "equilibrium_temperature" do
    expect(Sun.equilibrium_temperature(0.31649)).to eq(30)
  end
end
