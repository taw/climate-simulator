class Ground
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

  ### This stuff is not physically meaningful
  ### At least not until simulation reached equilibrium

  attr_reader :temp

  def slice_average_temp(start_i, end_i)
    (start_i..end_i).map{|i| @temp[i % 360] }.avg
  end

  def daily_outgoing_radiation(i)
    Sun.emissions @temp[i]
  end

  def daily_equilibrium_temperature(season)
    Sun.equilibrium_temperature(daily_incoming_radiation(season))
  end

  # It doesn't matter terribry much where we start,
  # convergence could be faster if we do something reasonable
  def start_simulation
    # @temp = 360.times.map{|i|
    #   Sun.equilibrium_temperature(daily_incoming_radiation(i / 360.0))
    # }
    @temp = 360.times.map{ 0.0 }
  end

  def advance_simulation(alpha=0.1)
    balances = 360.times.map do |i|
      season = i / 360.0
      (@incoming[i] - daily_outgoing_radiation(i)) / @capacity
    end

    new_temps = 360.times.map do |i|
      forw_temp = [@temp[i-1] + balances[i-1], -273.15].max
      new_temp = @temp[i] * (1 - alpha) + forw_temp * alpha
    end
    total_dt = new_temps.zip(@temp).map{|u,v| u-v}.map(&:abs).sum
    @temp = new_temps

    total_dt
  end
end
