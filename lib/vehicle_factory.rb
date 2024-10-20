class VehicleFactory
  def create_vehicles(vehicle_data)
    created_vehicles = []

    vehicle_data.each do |vehicle|
      vehicle = Vehicle.new({vin: vehicle[:"vin_1_10"],
                             year: vehicle[:"model_year"].to_i,
                             make: vehicle[:"make"].capitalize,
                             model: vehicle[:"model"],
                             engine: :ev
                            })

      created_vehicles << vehicle
    end

    created_vehicles
  end
end