# This function only works if each routing wire shape corresponds
# to one parasitic resistive model.
proc fetch_segments_rc { net_to_segments_var } {
  upvar 1 $net_to_segments_var net_to_segments

  foreach sta_net [get_nets -hierarchical *] {
    set db_net [sta::sta_to_db_net $sta_net]
    set type [$db_net getSigType]

    if { !([string equal $type "CLOCK"] || [string equal $type "SIGNAL"]) } {
      continue
    }

    set wire [$db_net getWire]

    if { $wire eq "NULL" } {
      continue
    }

    set segments {}
    set seen_shape_ids {}
    foreach rseg [$db_net getRSegs] {
      set shape [$wire getShape [$rseg getShapeId]]

      # We skip vias as they have no capacitance in RCX.
      if { ![$shape isSegment] } {
        continue
      }

      set shape_id [$rseg getShapeId]

      if { $shape_id in $seen_shape_ids } {
        error "Could not fetch segment parasitics data: shape\
               $shape_id on net [$db_net getName] has multiple rsegs."
      }

      set layer [[$shape getTechLayer] getName]

      set width [$shape getDX]
      set height [$shape getDY]
      set length_um [ord::dbu_to_microns [expr { max($width, $height) }]]

      # Default corner
      set corner 0
      set resistance [$rseg getResistance $corner]
      set capacitance [$rseg getTotalCapacitance $corner]

      lappend segments $layer $length_um $resistance $capacitance
      lappend seen_shape_ids $shape_id
    }

    set net_to_segments([get_full_name $sta_net]) $segments
  }
}

proc write_segment_rc_csv { filename net_to_segments_var } {
  upvar 1 $net_to_segments_var net_to_segments

  set stream [open $filename "w"]

  # First, write a header listing the routing layers in stack order.
  puts -nonewline $stream "# routing layers:"
  foreach layer [[ord::get_db_tech] getLayers] {
    if { [$layer getRoutingLevel] != 0 } {
      puts -nonewline $stream " [$layer getName]"
    }
  }

  puts $stream ""

  # Then, write the parasitics data of each wire segment.
  foreach sta_net [get_nets -hierarchical *] {
    set net_name [get_full_name $sta_net]

    if { ![info exists net_to_segments($net_name)] } {
      continue
    }

    set db_net [sta::sta_to_db_net $sta_net]
    set type [$db_net getSigType]
    set net_type [expr { $type eq "CLOCK" ? "clock" : "signal" }]

    foreach {layer length_um resistance capacitance} $net_to_segments($net_name) {
      puts $stream [format "%s,%s,%s,%.3e,%.3e,%.3e" \
        $net_name $net_type $layer $length_um $resistance $capacitance]
    }
  }

  close $stream
}
