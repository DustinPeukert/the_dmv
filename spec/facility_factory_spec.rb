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
      expect(created_facilities[0].address).to eq("2855 Tremont Place Suite 118 Denver CO 80205") #has address line 2 in data
      expect(created_facilities[0].phone).to eq("(720) 865-4600")

      expect(created_facilities[2].name).to eq("DMV Northwest Branch")
      expect(created_facilities[2].address).to eq("3698 W. 44th Avenue Denver CO 80211") #does not have address line 2 in data
      expect(created_facilities[2].phone).to eq("(720) 865-4600")
    end
    
    it 'can create facilities using data sets with different formats' do
      ny_dmv_info = DmvDataService.new.ny_dmv_office_locations
      mo_dmv_info = DmvDataService.new.mo_dmv_office_locations

      expect(ny_dmv_info.count).to eq(173)
      expect(mo_dmv_info.count).to eq(178)
  
      ny_facilities = @facility_factory.create_facilities(ny_dmv_info)
      mo_facilities = @facility_factory.create_facilities(mo_dmv_info)

      expect(ny_facilities).to be_an(Array)
      expect(mo_facilities).to be_an(Array)
      expect(ny_facilities.count).to eq(173)
      expect(mo_facilities.count).to eq(178)

      ny_facilities.each do |facility|
        expect(facility).to be_an_instance_of(Facility)
      end

      mo_facilities.each do |facility|
        expect(facility).to be_an_instance_of(Facility)
      end

      expect(ny_facilities[0].name).to eq("LAKE PLACID")
      expect(ny_facilities[0].address).to eq("2693 MAIN STREET LAKE PLACID NY 12946")
      expect(ny_facilities[0].phone).to eq(nil) #data does not have phone number, so returns nil

      expect(mo_facilities[0].name).to eq("FERGUSON-OFFICE CLOSED UNTIL FURTHER NOTICE")
      expect(mo_facilities[0].address).to eq("10425 WEST FLORISSANT FERGUSON MO 63136")
      expect(mo_facilities[0].phone).to eq("(314) 733-5316")
    end
  end
end