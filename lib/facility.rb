class Facility
  attr_reader :name,
              :address,
              :phone,
              :services,
              :registered_vehicles,
              :collected_fees

  def initialize(facility_info)
    @name = facility_info[:name]
    @address = facility_info[:address]
    @phone = facility_info[:phone]
    @services = []
    @registered_vehicles = []
    @collected_fees = 0
  end

  def add_service(service)
    @services << service
  end

  def register_vehicle(vehicle)
    if @services.include?('Vehicle Registration')
      vehicle.set_registration_date
      vehicle.set_plate_type

      if vehicle.plate_type == :ev
        @collected_fees += 200
      elsif vehicle.plate_type == :regular
        @collected_fees += 100
      elsif vehicle.plate_type == :antique
        @collected_fees += 25
      end

      @registered_vehicles << vehicle
    else
      'We do not provide this service: Vehicle Registration'
    end
  end
end
