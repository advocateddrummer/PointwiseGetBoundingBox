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

  foreach {n things} [array get selected] {
    #puts "--$n: $things [llength $things]"

    if { $n == "Boundaries" } {
      set curves [list]
      foreach thing $things {
        lappend curves [pw::Database getCurve $thing]
      }
      set things $curves
    }

    foreach thing $things {
      set bbox [pwu::Extents enclose $bbox [$thing getExtents]]
    }
  }

set bboxMin [pwu::Extents minimum $bbox]
set bboxMax [pwu::Extents maximum $bbox]
set bboxDeltas [pwu::Vector3 subtract $bboxMax $bboxMin]

puts ""
puts "Bounding box is:"
puts "$bboxMin -> $bboxMax"
puts ""
puts "Bounding box deltas:"
puts "$bboxDeltas"
puts ""
puts "Completed getBBox script..."
exit

# vim: filetype=tcl
