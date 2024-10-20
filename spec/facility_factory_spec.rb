require 'spec_helper'

describe FacilityFactory do
  before(:each) do
    @facility_factory = FacilityFactory.new
  end

  describe '#initialize' do
    it 'is an instance of FacilityFactory' do
      expect(@facility_factory).to be_an_instance_of(FacilityFactory)
    end
  end

  describe '#create_facilites' do
    it 'creates facilities using stored API data' do
      co_dmv_info = DmvDataService.new.co_dmv_office_locations
      created_facilities = @facility_factory.create_facilities(co_dmv_info)

      expect(co_dmv_info.count).to eq(5)
      expect(created_facilities.count).to eq(5)

      expect(created_facilities).to be_an(Array)

      created_facilities.each do |facility|
        expect(facility).to be_an_instance_of(Facility)
      end

      expect(created_facilities[0].name).to eq("DMV Tremont Branch")
      expect(created_facilities[0].address).to eq("2855 Tremont Place Suite 118 Denver CO 80205")
      expect(created_facilities[0].phone).to eq("(720) 865-4600")
    end
  end
end