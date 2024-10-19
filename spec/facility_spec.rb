require 'spec_helper'

RSpec.describe Facility do
  before(:each) do
    @facility_1 = Facility.new({name: 'DMV Tremont Branch', address: '2855 Tremont Place Suite 118 Denver CO 80205', phone: '(720) 865-4600'})
    @facility_2 = Facility.new({name: 'DMV Northeast Branch', address: '4685 Peoria Street Suite 101 Denver CO 80239', phone: '(720) 865-4600'})
    @cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice})
    @bolt = Vehicle.new({vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev})
    @camaro = Vehicle.new({vin: '1a2b3c4d5e6f', year: 1969, make: 'Chevrolet', model: 'Camaro', engine: :ice})
    @registrant_1 = Registrant.new('Bruce', 18, true)
    @registrant_2 = Registrant.new('Penny', 16)
    @registrant_3 = Registrant.new('Tucker', 15)
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
      @facility_1.add_service('Vehicle Registration')
      expect(@facility_1.services).to eq(['Vehicle Registration'])
      expect(@facility_2.services).to eq([])

      expect(@facility_1.register_vehicle(@cruz)).to eq([@cruz])
      expect(@facility_2.register_vehicle(@camaro)).to eq('We do not provide this service: Vehicle Registration')

      expect(@facility_1.registered_vehicles).to eq([@cruz])
      expect(@facility_2.registered_vehicles).to eq([])
    end

    it 'can register more than 1 vehicle' do
      @facility_1.add_service('Vehicle Registration')
      expect(@facility_1.services).to eq(['Vehicle Registration'])

      expect(@facility_1.register_vehicle(@cruz)).to eq([@cruz])
      expect(@facility_1.register_vehicle(@camaro)).to eq([@cruz, @camaro])
      expect(@facility_1.register_vehicle(@bolt)).to eq([@cruz, @camaro, @bolt])

      expect(@facility_1.registered_vehicles).to eq([@cruz, @camaro, @bolt])
    end

    context 'vehicle is antique' do
      it 'collects $25 upon registration' do
        @facility_1.add_service('Vehicle Registration')
        @facility_1.register_vehicle(@camaro)

        expect(@facility_1.collected_fees).to eq(25)
      end
    end

    context 'vehicle is electric(EV)' do
      it 'collects $200 upon registration' do
        @facility_1.add_service('Vehicle Registration')
        @facility_1.register_vehicle(@bolt)

        expect(@facility_1.collected_fees).to eq(200)
      end
    end

    context 'vehicle is neither antique nor electric(EV)' do
      it 'collects $100 upon registration' do
        @facility_1.add_service('Vehicle Registration')
        @facility_1.register_vehicle(@cruz)

        expect(@facility_1.collected_fees).to eq(100)
      end
    end

    it 'can accumulate fees' do
      @facility_1.add_service('Vehicle Registration')
      @facility_1.register_vehicle(@cruz)
      @facility_1.register_vehicle(@bolt)
      @facility_1.register_vehicle(@camaro)

      expect(@facility_1.collected_fees).to eq(325)
    end
  end

  describe '#administer_written_test' do
    context 'facility does not provide Written Test service' do
      it 'cannot administer a test to a registrant' do
        expect(@registrant_1.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
        expect(@registrant_1.permit?).to be true
        expect(@facility_1.services).to eq([])

        expect(@facility_1.administer_written_test(@registrant_1)).to be false
        expect(@registrant_1.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
      end
    end

    context 'facility provides Written Test services' do
      it 'can administer test to a registrant' do
        expect(@registrant_1.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
        expect(@registrant_1.permit?).to be true

        @facility_1.add_service('Written Test')
        expect(@facility_1.services).to eq(['Written Test'])

        expect(@facility_1.administer_written_test(@registrant_1)).to be true
        expect(@registrant_1.license_data).to eq({:written=>true, :license=>false, :renewed=>false})
      end

      it 'requires registrant to have a permit' do
        expect(@registrant_2.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
        expect(@registrant_2.permit?).to be false
        expect(@registrant_2.age).to eq(16)

        @facility_1.add_service('Written Test')
        expect(@facility_1.services).to eq(['Written Test'])

        expect(@facility_1.administer_written_test(@registrant_2)).to be false
        expect(@registrant_2.license_data).to eq({:written=>false, :license=>false, :renewed=>false})

        @registrant_2.earn_permit

        expect(@facility_1.administer_written_test(@registrant_2)).to be true
        expect(@registrant_2.license_data).to eq({:written=>true, :license=>false, :renewed=>false})
      end

      it 'requires registrants to be 16+' do
        expect(@registrant_3.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
        expect(@registrant_3.permit?).to be false
        expect(@registrant_3.age).to eq(15)

        expect(@facility_1.administer_written_test(@registrant_3)).to be false
        @registrant_3.earn_permit

        expect(@facility_1.administer_written_test(@registrant_3)).to be false
        expect(@registrant_3.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
      end
    end
  end

  describe '#administer_road_test' do
    context 'facility does not provide service' do
      it 'cannot administer test' do
        expect(@facility_1.services).to eq([])
        expect(@facility_1.administer_road_test(@registrant_1)).to be false
        expect(@registrant_1.license_data[:license]).to be false
      end
    end

    context 'registrant has not passed their written test' do
      it 'cannot administer test' do
        @facility_1.add_service('Road Test')

        expect(@registrant_1.license_data[:written]).to be false
        expect(@facility_1.administer_road_test(@registrant_1)).to be false
        expect(@registrant_1.license_data[:license]).to be false
      end
    end

    context 'registrant passed written test and service is provided' do
      it 'can administer test' do
        @facility_1.add_service('Road Test')
        @facility_1.administer_written_test(@registrant_1)

        expect(@registrant_1.license_data[:written]).to be true
        expect(@facility_1.administer_written_test(@registrant_1)).to be true
        expect(@registrant_1.license_data[:license]).to be true
      end
    end
  end
end
