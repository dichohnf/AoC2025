#!/usr/bin/tclsh

set fp [open "input" r]
set file_text [read $fp]
close $fp

set lines [split $file_text "\n"]

set pos 50
set counter 0
puts [format "\[Counter %d\] Starting position %d" $counter $pos]

foreach line $lines {
  set current_value [string range $line 1 end]
  set rest [expr {$current_value / 100}]
  set mod [expr {$current_value % 100}]

  incr counter $rest

  if {[string equal [string index $line 0] "L"]} {
    if {$pos <= $mod && $pos > 0} {
      incr counter
    }
    set pos [expr {($pos - $mod) % 100}]
  } else {
    if {[expr {($pos + $mod) >= 100}]} {
      incr counter
    }
    set pos [expr {($pos + $mod) % 100}]
  }
  puts [format "line %3s => Pos: %2d Counter: %4d" $line $pos $counter]
}
puts [format "\[Counter %d\] Position %d" $counter $pos]