require 'spec_helper'
require 'date'

RSpec.describe Vehicle do
  before(:each) do
    @cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice} )
    @bolt = Vehicle.new({vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev} )
    @camaro = Vehicle.new({vin: '1a2b3c4d5e6f', year: 1969, make: 'Chevrolet', model: 'Camaro', engine: :ice} )
  end
  
  describe '#initialize' do
    it 'can initialize' do
      expect(@cruz).to be_an_instance_of(Vehicle)
      expect(@cruz.vin).to eq('123456789abcdefgh')
      expect(@cruz.year).to eq(2012)
      expect(@cruz.make).to eq('Chevrolet')
      expect(@cruz.model).to eq('Cruz')
      expect(@cruz.engine).to eq(:ice)
      expect(@cruz.registration_date).to be nil
      expect(@cruz.plate_type).to be nil
    end
  end

  describe '#antique?' do
    it 'can determine if a vehicle is an antique' do
      expect(@cruz.antique?).to eq(false)
      expect(@bolt.antique?).to eq(false)
      expect(@camaro.antique?).to eq(true)
    end
  end

  describe '#electric_vehicle?' do
    it 'can determine if a vehicle is an ev' do
      expect(@cruz.electric_vehicle?).to eq(false)
      expect(@bolt.electric_vehicle?).to eq(true)
      expect(@camaro.electric_vehicle?).to eq(false)
    end
  end

  describe '#set_registration_date' do
    it 'sets the date of registration upon method call' do
      expect(@cruz.registration_date).to be nil

      @cruz.set_registration_date

      expect(@registration_date).to be_an_instance_of(Date)
      expect(@registration_date).to eq(Date.today)
    end
  end

  describe '#set_plate_type' do
    context 'vehicle is not antique or electric(EV)' do
      it 'sets the plate type to :regular' do
        expect(@cruz.antique?).to be false
        expect(@cruz.electric_vehicle?).to be false
        expect(@cruz.plate_type).to be nil

        @cruz.set_plate_type

        expect(@cruz.plate_type).to eq(:regular)
      end
    end

    context 'vehicle is electric(EV)' do
      it 'sets the plate_type to :ev' do
        expect(@bolt.antique?).to be false # don't need this but consistency
        expect(@bolt.electric_vehicle?).to be true
        expect(@bolt.plate_type).to be nil

        @bolt.set_plate_type

        expect(@bolt.plate_type).to eq(:ev)
      end
    end

    context 'vehicle is an antique' do
      it 'sets the plate_type to :antique' do
        expect(@camaro.antique).to be true
        expect(@camaro.electric_vehicle?).to be false
        expect(@camaro.plate_type).to be nil

        @camaro.set_plate_type

        expect(@camaro.plate_type).to eq(:antique)
      end
    end
  end
end
