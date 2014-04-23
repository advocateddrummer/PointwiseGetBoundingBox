package require PWI_Glyph 2.17.1

puts "Beginning getBBox script..."

set mask [pw::Display createSelectionMask \
  -requireConnector {} \
  -requireDomain {} \
  -requireBlock {}];# \
  -requireDatabase {} \
  -requireDatabaseBoundary {}]

if { [pw::Display selectEntities \
       -selectionmask $mask \
       -description "Select entities for bounding box" \
     selected] } {

  #puts "--Successfully selected entities..."

  set xMin 1e100
  set yMin 1e100
  set zMin 1e100
  set xMax -1e100
  set yMax -1e100
  set zMax -1e100

  foreach {n things} [array get selected] {
    #puts "--$n: $things [llength $things]"

    for {set i 0} {$i < [llength $things]} {incr i} {
      set thing [lindex $things $i]
      #puts "----$thing"
      #puts "----[$thing getName]"
      set ent [pw::GridEntity getByName [$thing getName]]
      set nPoints [$ent getPointCount]
      #puts "----$ent"
      #puts "----$nPoints"

      for {set j 1} {$j <= $nPoints} {incr j} {
        set xyz [$ent getXYZ -grid $j]
        set x [pwu::Vector3 index $xyz 0]
        set y [pwu::Vector3 index $xyz 1]
        set z [pwu::Vector3 index $xyz 2]

        set xMin [::tcl::mathfunc::min $xMin $x]
        set yMin [::tcl::mathfunc::min $yMin $y]
        set zMin [::tcl::mathfunc::min $zMin $z]
        set xMax [::tcl::mathfunc::max $xMax $x]
        set yMax [::tcl::mathfunc::max $yMax $y]
        set zMax [::tcl::mathfunc::max $zMax $z]

      }
    }
  }
} else {
  puts "Error: Unsuccessfully selected entities... exiting"
  exit
}

puts ""
puts "Bounding box is:"
puts "($xMin, $yMin, $zMin) -> ($xMax, $yMax, $zMax)"
puts ""
puts "Completed getBBox script..."
exit

# vim: filetype=tcl
