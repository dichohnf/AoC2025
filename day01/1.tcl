#!/usr/bin/tclsh

set fp [open "input" r]
set file_text [read $fp]
close $fp

set lines [split $file_text "\n"]

set pos 50
set counter 0
foreach line $lines {
  set current_value [string range $line 1 end]
  if {[string equal [string index $line 0] "L"]} {
    set pos [expr {($pos - $current_value) % 100}]
  } else {
    set pos [expr {($pos + $current_value) % 100}]
  }
  if {$pos == 0} {
    incr counter
  }
}

puts $counter