# radians are mostly just annoying
module Math
  def self.dcos(deg)
    cos(deg / 180.0 * Math::PI)
  end

  def self.dsin(deg)
    sin(deg / 180.0 * Math::PI)
  end
end

class Sun
  def tilt
    23.45
  end

  # 0 - winter, 0.5 summer
  def declination(season)
    (-Math.cos(season * 2 * Math::PI) * tilt).round(2)
  end

  # 0 - midnight, 12 - noon, 24 - midnight
  def hour_angle(hour)
    hour %= 24.0
    ((hour - 12) * 15).round(2)
  end

  def altitude(lat, season, hour)
    sin_aa = sin_altitude(lat, season, hour)
    (Math.asin(sin_aa) * 180.0 / Math::PI).round(2)
  end

  private def sin_altitude(lat, season, hour)
    d = declination(season)
    ha = hour_angle(hour)
    (
      Math.dcos(lat) * Math.dcos(d) * Math.dcos(ha) +
      Math.dsin(lat) * Math.dsin(d)
    ).round(6)
  end

  def radiation(lat, season, hour)
    [0, sin_altitude(lat, season, hour)].max
  end

  # No easy formula, so just try numerically
  def daily_radiation(lat, season)
    ((0..23).map do |h|
      radiation(lat, season, h)
    end.sum / 24.0).round(6)
  end
end
