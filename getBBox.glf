package require PWI_Glyph 2.17.1

puts "Beginning getBBox script..."

set mask [pw::Display createSelectionMask \
          -requireConnector {} \
          -requireDomain {} \
          -requireBlock {} \
          -requireDatabase {} \
          -requireDatabaseBoundary {}]

  #
  # Use selected entity(ies) or prompt user for selection if nothing is selected
  # at run time.
  #
  if { !([pw::Display getSelectedEntities -selectionmask $mask selected]) } {

    if { !([pw::Display selectEntities \
            -selectionmask $mask \
            -description "Select entities for bounding box" \
            selected]) } {

      puts "Error: Unsuccessfully selected entities... exiting"
      exit
    }
  }

  #puts "--Successfully selected entities..."

  set bbox [pwu::Extents empty]

  set startTime [pwu::Time now]

  foreach {n things} [array get selected] {
    #puts "--$n: $things [llength $things]"

    foreach thing $things {
      set bbox [pwu::Extents enclose $bbox [$thing getExtents]]
    }
  }

puts ""
puts "Bounding box is:"
puts "[pwu::Extents minimum $bbox] -> [pwu::Extents maximum $bbox]"
puts ""
puts "Completed getBBox script."
puts "Total elapsed time is [pwu::Time elapsed $startTime] seconds"

exit

# vim: filetype=tcl
