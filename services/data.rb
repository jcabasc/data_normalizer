require './services/vehicle.rb'

module Services
  class Data
    def self.call(input)
      vehicle = Services::Vehicle.new(input)
      return vehicle.normalized
    end
  end
end