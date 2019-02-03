class Ground
  attr_reader :capacity, :lat, :sun

  def initialize(capacity, lat, sun)
    @capacity = capacity
    @lat = lat
    @sun = sun
    # cache
    @incoming = (0...360).map{|i| daily_incoming_radiation(i / 360.0)}
  end

  def daily_incoming_radiation(season)
    @sun.daily_radiation(@lat, season)
  end

  def monthly_average_radiation(month)
    (month*30...(month+1)*30).map{|j| @incoming[j] }.avg
  end

  def annual_average_radiation
    (0...12).map{|month| monthly_average_radiation(month) }.avg
  end

  def daily_equilibrium_temperature(season)
    Sun.equilibrium_temperature(daily_incoming_radiation(season))
  end

  ### This stuff is not physically meaningful
  ### At least not until simulation reached equilibrium

  attr_reader :temp

  def average_annual_temp
    @temp.avg
  end

  # Start somewhere reasonable for decent convergence
  def start_simulation
    t = Sun.equilibrium_temperature(annual_average_radiation)
    @temp = 12.times.map{ t }
  end

  # Just make climate happen, no trickery!
  def advance_simulation
    total_dt = 0.0
    12.times do |i|
      inext = (i+1) % 12
      energy_diff = (monthly_average_radiation(i) - Sun.emissions(@temp[i]))
      forw_temp = @temp[i] + energy_diff / @capacity
      forw_temp = [forw_temp, -273.15].max
      total_dt += (@temp[inext] - forw_temp).abs
      @temp[inext] = forw_temp
    end
    total_dt
  end
end
