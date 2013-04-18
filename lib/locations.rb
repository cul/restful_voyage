module Voyager
  module Locations
    FIXED_LOCATIONS = {
      438 => 'Avery Circulation Desk',
      444 => 'Barnard Circulation Desk',
      572 => 'Burke Circulation Desk',
      440 => 'Business Circulation Desk',
      445 => 'Butler Circulation Desk',
      442 => 'East Asian Circ Desk',
      455 => 'Engineeering Circ Desk',
      453 => 'Geology Circ Desk',
      648 => 'Geoscience Circ Desk',
      449 => 'HSL Circulation Desk',
      471 => 'HSL Reserves Processing',
      456 => 'Journalism Circ Desk',
      447 => 'Lehman Circulation Desk',
      452 => 'Mathematics Circ Desk',
      448 => 'Music Circulation Desk',
      674 => 'Science Circulation Desk',
      576 => 'Social Work Circ. Desk'
    }

    def self.list_all()
      FIXED_LOCATIONS
    end

    def self.default_pickup()
      445
    end
  end
end
