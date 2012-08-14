class DS
  def initialize # connect to data source...
  end
  
  def get_mouse_info(workstation_id) # ...
    "Dual Optical"
  end
  
  def get_mouse_price(workstation_id) # ...
    40
  end
  
  def get_keyboard_info(workstation_id) # ...
    "Standard UK"
  end
  
  def get_keyboard_price(workstation_id) # ...
    20
  end

  def get_cpu_info(workstation_id) # ...
      "2.16 Ghz"
    end

  def get_cpu_price(workstation_id) # ...
    220
  end

  def get_display_info(workstation_id) # ...
    "LED 1280x1024"
  end

  def get_display_price(workstation_id) # ...
  # ...and so on
    150
  end
end
