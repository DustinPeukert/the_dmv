class FacilityFactory
  def create_facilities(facility_data)
    created_facilities = []

    facility_data.each do |facility|
      address_main = facility[:"address_li"] || # using || will return the first non-nil value
                     facility[:"street_address_line_1"] || #its called short circuit evaluation
                     facility[:"address1"]

      address_sub = facility[:"address__1"] ||
                    facility[:"street_address_line_2"]
            
      city = facility[:"city"]

      state = facility[:"state"]

      zip = facility[:"zip"] ||
            facility[:"zip_code"] ||
            facility[:"zipcode"]

      name = facility[:"dmv_office"] ||
             facility[:"office_name"] ||
             facility[:"name"]
      
      phone = facility[:"phone"] ||
              facility[:"public_phone_number"]

      if address_sub != nil
        full_address = [address_main, address_sub, city, state, zip].join(" ")
      else
        full_address = [address_main, city, state, zip].join(" ")
      end

      new_facility = Facility.new({name: name,
                                   address: full_address,
                                   phone: phone
                                  })
      created_facilities << new_facility
    end

    created_facilities
  end
end