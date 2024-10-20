class FacilityFactory
  def create_facilities(facility_data)
    created_facilities = []

    facility_data.each do |facility|
      address_main = facility[:"address_li"]
      address_sub = facility[:"address__1"]
      city = facility[:"city"]
      state = facility[:"state"]
      zip = facility[:"zip"]

      full_address = [address_main, address_sub, city, state, zip].join(" ")

      new_facility = Facility.new({name: facility[:"dmv_office"],
                                   address: full_address,
                                   phone: facility[:"phone"]
                                  })
      created_facilities << new_facility
    end

    created_facilities
  end
end