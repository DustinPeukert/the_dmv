require 'spec_helper'

RSpec.describe Facility do
  before(:each) do
    @facility_1 = Facility.new({name: 'DMV Tremont Branch', address: '2855 Tremont Place Suite 118 Denver CO 80205', phone: '(720) 865-4600'})
    @facility_2 = Facility.new({name: 'DMV Northeast Branch', address: '4685 Peoria Street Suite 101 Denver CO 80239', phone: '(720) 865-4600'})
    @cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice})
    @bolt = Vehicle.new({vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev})
    @camaro = Vehicle.new({vin: '1a2b3c4d5e6f', year: 1969, make: 'Chevrolet', model: 'Camaro', engine: :ice})
  end

  describe '#initialize' do
    it 'can initialize' do
      expect(@facility_1).to be_an_instance_of(Facility)
      expect(@facility_1.name).to eq('DMV Tremont Branch')
      expect(@facility_1.address).to eq('2855 Tremont Place Suite 118 Denver CO 80205')
      expect(@facility_1.phone).to eq('(720) 865-4600')
      expect(@facility_1.services).to eq([])
      expect(@facility_1.registered_vehicles).to eq([])
      expect(@facility_1.collected_fees).to eq(0)
    end
  end

  describe '#add service' do
    it 'can add available services' do
      expect(@facility_1.services).to eq([])
      @facility_1.add_service('New Drivers License')
      @facility_1.add_service('Renew Drivers License')
      @facility_1.add_service('Vehicle Registration')
      expect(@facility_1.services).to eq(['New Drivers License', 'Renew Drivers License', 'Vehicle Registration'])
    end
  end

  describe '#register_vehicle' do
    it 'can register a vehicle' do
      expect(@cruz.registration_date).to be nil
      expect(@cruz.plate_type).to be nil
      expect(@facility_1.registered_vehicles).to eq([])
      
      @facility_1.add_service('Vehicle Registration')
      expect(@facility_1.register_vehicle(@cruz)).to eq([@cruz])

      expect(@cruz.registration_date).to be_a(Date) #Date.today
      expect(@cruz.registration_date).to eq(Date.today)
      expect(@cruz.plate_type).to eq(:regular)

      expect(@facility_1.registered_vehicles).to eq([@cruz])
    end

    it 'can only do so if facility provides that service' do
      expect(@facility_1.services).to eq(['Vehicle Registration'])
      expect(@facility_2.services).to eq([])

      @facility_1.add_service('Vehicle Registration')
      expect(@facility_1.register(@cruz)).to eq([@cruz])
      expect(@facility_2.register(@camaro)).to eq('We do not provide this service: Vehicle Registration')

      expect(@facility_1.registered_vehicles).to eq([@cruz])
      expect(@facility_2.registered_vehicles).to eq([])
    end

    it 'can register more than 1 vehicle' do
      expect(@facility_1.services).to eq(['Vehicle Registration'])

      @facility_1.add_service('Vehicle Registration')

      expect(@facility_1.register(@cruz)).to eq([@cruz])
      expect(@facility_1.register(@camaro)).to eq([@cruz, @camaro])
      expect(@facility_1.register(@bolt)).to eq([@cruz, @camaro, @bolt])

      expect(@facility_1.services).to eq([@cruz, @camaro, @bolt])
    end
  end
end
