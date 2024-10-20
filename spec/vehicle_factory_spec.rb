require 'spec_helper'

describe VehicleFactory do
  before(:each) do
    @vehicle_factory = VehicleFactory.new
  end

  describe '#initialize' do
    it 'is an instance of VehicleFactory' do
      expect(@vehicle_factory).to be_an_instance_of(VehicleFactory)
    end
  end

  describe '#create_vehicles' do
    it 'creates vehicles using stored API data' do
      wa_ev_registrations = DmvDataService.new.wa_ev_registrations
      created_vehicles = @vehicle_factory.create_vehicles(wa_ev_registrations)
      
      expect(wa_ev_registrations.count).to eq(1000)
      expect(created_vehicles.count).to eq(1000)

      expect(created_vehicles).to be_an(Array)

      created_vehicles.each do |vehicle|
        expect(vehicle).to be_an_instance_of(Vehicle)
      end
    end
  end
end