set_io_pin_constraint -pin_names {clock_i enable_i reset_n_i} -region left:*
# set_io_pin_constraint -pin_names {reg0[*]} -region left:* # Example for Bus
set_io_pin_constraint -pin_names {counter_value_o} -region right:*