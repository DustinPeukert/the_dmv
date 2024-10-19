require 'spec_helper'

describe Registrant do
  before(:each) do
    @registrant_1 = Registrant.new('Bruce', 18, true)
    @registrant_2 = Registrant.new('Penny', 15)
  end

  describe '#initialize' do
    it 'can initialize with different arguments' do
      expect(@registrant_1).to be_an_instance_of(Registrant)
      expect(@registrant_2).to be_an_instance_of(Registrant)

      expect(@registrant_1.name).to eq("Bruce")
      expect(@registrant_1.age).to eq(18)
      expect(@registrant_1.license_data).to eq({:written=>false, :license=>false, :renewed=>false})

      expect(@registrant_2.name).to eq("Penny")
      expect(@registrant_2.age).to eq(15)
      expect(@registrant_2.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
    end
  end

  describe '#permit?' do
    it 'checks if the registrant has a permit' do
      expect(@registrant_1.permit?).to be true
      expect(@registrant_2.permit?).to be false
    end
  end

  describe '#earn_permit' do
    it 'can earn a permit' do
      expect(@registrant_2.permit?).to be false

      @registrant_2.earn_permit

      expect(@registrant_2.permit?).to be true

      @registrant_2.earn_permit

      expect(@registrant_2.permit?).to be true
    end
  end

  describe '#pass_written_test' do
    it 'changes license data to reflect passing of test' do
      expect(@registrant_1.license_data).to eq({:written=>false, :license=>false, :renewed=>false})

      @registrant_1.pass_written_test

      expect(@registrant_1.license_data).to eq({:written=>true, :license=>false, :renewed=>false})
    end
  end

  describe '#will_pass_written?' do
    context 'registrant has their permit and is 16+' does
      it 'will pass the test' do
        expect(@registrant_1.permit?).to be true
        expect(@registrant_1.age >= 16).to be true
        expect(@registrant_1.will_pass_test?).to be true
      end
    end

    context 'registrant does not have a permit or is not 16+' do
      it 'will not pass the test' do
        expect(@registrant_2.permit?).to be false
        expect(@registrant_2.age >= 16).to be false
        expect(@registrant_2.will_pass_test).to be false
      end
    end
  end

  describe '#will_pass_road?' do
    context 'registrant has passed their written test' do
      it 'will pass its road test' do
        @registrant.pass_written_test

        expect(@registrant_1.license_data[:written]).to be true
        expect(@registrant_1.will_pass_road?).to be true
      end
    end

    context 'registrant has not passed their written test' do
      it 'will not pass its road test' do
        expect(@registrant_1.license_data[:written]).to be false
        expect(@registrant_1.will_pass_road?).to be false
      end
    end
  end
end