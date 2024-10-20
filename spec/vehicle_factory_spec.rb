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
end