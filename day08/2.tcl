#!/usr/bin/tclsh

set input "input"

set fp [open $input r]
set file_text [read $fp]
close $fp
set lines [split $file_text "\n"]

set points {}
set point_circuit {}
for {set idx 0} {$idx < [llength $lines]} {incr idx} {
  set line [lindex $lines $idx]
  lappend points [split $line ","]
  dict set point_circuit [split $line ","] $idx
}

set distances {}

for {set i 0} {$i < [llength $points]} {incr i} {
  set first [lindex $points $i]
  set fx [lindex $first 0]
  set fy [lindex $first 1]
  set fz [lindex $first 2]
  for {set j [expr $i + 1]} {$j < [llength $points]} {incr j} {
    set second [lindex $points $j]
    set sx [lindex $second 0]
    set sy [lindex $second 1]
    set sz [lindex $second 2]

    set distance_squared [expr {($fx-$sx)**2 + ($fy-$sy)**2 + ($fz-$sz)**2}]
    lappend distances [list $first $second $distance_squared]
  }
}

set distances [lsort -integer -index 2 $distances]

set iteration 0
set circuits {}

while {[llength [lindex $circuits 0]] != [llength $points]} {
  set distance [lindex $distances $iteration]
  set first [lindex $distance 0]
  set second [lindex $distance 1]

  set circuit_first_idx -1
  set circuit_second_idx -1
  for {set circuit_idx 0} {$circuit_idx < [llength $circuits]} {incr circuit_idx} {
    set circuit [lindex $circuits $circuit_idx]
    if {[lsearch $circuit $first] > -1} {
        set circuit_first_idx $circuit_idx
    }
    if {[lsearch $circuit $second] > -1} {
      set circuit_second_idx $circuit_idx
    }
  }

  if {$circuit_first_idx == -1 && $circuit_second_idx == -1} {
    lappend circuits [list $first $second]
  } elseif {$circuit_first_idx == -1 && $circuit_second_idx != -1} {
    set circuit [lindex $circuits $circuit_second_idx]
    lappend circuit $first
    set circuits [lreplace $circuits $circuit_second_idx $circuit_second_idx $circuit]
  } elseif {$circuit_first_idx != -1 && $circuit_second_idx == -1} {
    set circuit [lindex $circuits $circuit_first_idx]
    lappend circuit $second
    set circuits [lreplace $circuits $circuit_first_idx $circuit_first_idx $circuit]
  } elseif {$circuit_first_idx != $circuit_second_idx} {
    set circuit_first [lindex $circuits $circuit_first_idx]
    set circuit_second [lindex $circuits $circuit_second_idx]
    set circuit [concat $circuit_first $circuit_second]
    set circuits [lreplace $circuits $circuit_first_idx $circuit_first_idx $circuit]
    set circuits [lreplace $circuits $circuit_second_idx $circuit_second_idx]
  }

  incr iteration
}

set fx [lindex $first 0]
set sx [lindex $second 0]

puts [format "Mult. of X coordinates: %d" [expr $fx * $sx]]