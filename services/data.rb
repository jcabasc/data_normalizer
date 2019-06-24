# frozen_string_literal: true

require './services/vehicle.rb'

module Services
  class Data # :nodoc:
    def self.call(input)
      vehicle = Services::Vehicle.new(input)
      vehicle.normalized
    end
  end
end
