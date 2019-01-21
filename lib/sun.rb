class Sun
  def tilt
    23.45
  end

  # 0 - winter, 0.5 summer
  def declination(phase)
    (-Math.cos(phase * 2 * Math::PI) * tilt).round(2)
  end
end
