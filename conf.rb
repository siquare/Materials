require './stdlib'

module Conf
  @@conf = {}

  @@conf[:move_area_min] = Point.new 10, 10
  @@conf[:move_area_max] = Point.new 630, 470

  @@conf[:player_init_x] = 50
  @@conf[:player_init_y] = 50
end
