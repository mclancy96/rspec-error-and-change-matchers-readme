# frozen_string_literal: true

# Represents a thermostat that controls a room's temperature
class Thermostat
  attr_reader :temperature, :mode

  def initialize
    @temperature = 70
    @mode = :off
  end

  def set_temperature(temp)
    raise ArgumentError, "Temperature out of range" unless (50..90).include?(temp)
    @temperature = temp
  end

  def turn_on
    @mode = :heat
  end

  def turn_off
    @mode = :off
  end

  def increase_temp
    set_temperature(@temperature + 1)
  end

  def decrease_temp
    set_temperature(@temperature - 1)
  end
end

# Represents a room with a thermostat
class Room
  attr_reader :thermostat, :name

  def initialize(name)
    @name = name
    @thermostat = Thermostat.new
  end
end
