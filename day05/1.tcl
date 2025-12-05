#!/usr/bin/tclsh

set fp [open "input" r]
set file_text [read $fp]
close $fp
set lines [split $file_text "\n"]


set ranges {}
set row 0
set line [lindex $lines $row]
while {$line ne ""} {
    lappend ranges [regsub -- "-" $line " "]
    incr row
    set line [lindex $lines $row]
}

set count 0
while {$row<[llength $lines]} {
    incr row
    set val [lindex $lines $row]
    foreach range $ranges {
        if {[lindex $range 0]<=$val && $val<=[lindex $range 1]} {
            incr count
            break
        }
    }
}

puts $count