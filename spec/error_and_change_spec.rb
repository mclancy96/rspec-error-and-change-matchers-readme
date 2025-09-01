
require 'thermostat'

RSpec.describe 'Thermostat error, change, and advanced matchers' do
  let(:thermostat) { Thermostat.new }
  let(:room) { Room.new('Living Room') }

  describe 'error matchers' do
    it 'raises error for out-of-range temperature' do
      expect { thermostat.set_temperature(45) }.to raise_error(ArgumentError, /out of range/)
    end

    it 'does not raise error for valid temperature' do
      expect { thermostat.set_temperature(72) }.not_to raise_error
    end
  end

  describe 'change matchers' do
    it 'changes temperature when increased' do
      expect { thermostat.increase_temp }.to change { thermostat.temperature }.by(1)
    end

    it 'changes temperature when decreased' do
      expect { thermostat.decrease_temp }.to change { thermostat.temperature }.by(-1)
    end

    it 'changes mode when turned on' do
      expect { thermostat.turn_on }.to change { thermostat.mode }.from(:off).to(:heat)
    end

    it 'does not change temperature when turning on' do
      expect { thermostat.turn_on }.not_to change { thermostat.temperature }
    end
  end

  describe 'respond_to and satisfy matchers' do
    it 'responds to set_temperature and turn_on' do
      expect(thermostat).to respond_to(:set_temperature).and respond_to(:turn_on)
    end

    it 'satisfies custom logic: temperature is even' do
      thermostat.set_temperature(68)
      expect(thermostat.temperature).to satisfy { |t| t.even? }
    end
  end

  describe 'compound matchers' do
    it 'temperature is between 60 and 80' do
      thermostat.set_temperature(75)
  expect(thermostat.temperature).to (be > 60).and be < 80
    end

    it 'mode is :off or :heat' do
      expect(thermostat.mode).to eq(:off).or eq(:heat)
    end
  end

  describe 'pending specs for students' do
    it 'is pending: test that setting temperature to 100 raises error' do
      pending("Student: Write a spec for error on 100 degrees")
      raise "Unimplemented pending spec"
    end

    it 'is pending: test that turning off thermostat changes mode from :heat to :off' do
      pending("Student: Write a spec for mode change on turn_off")
      raise "Unimplemented pending spec"
    end
  end
end
