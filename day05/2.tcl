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

set ranges [lsort -index 0 -integer $ranges]

set fresh_ids_count 1 ;# 1 because the first last_id_covered is not counted
set last_id_covered [lindex [lindex $ranges 0] 0 ]
foreach range $ranges {
    set left [lindex $range 0]
    set right [lindex $range 1]

    if {$last_id_covered >= $right} {
        continue
    }
    if {$last_id_covered < $left} {
        incr fresh_ids_count [expr {$right-$left+1}]
    } else {
        incr fresh_ids_count [expr {$right-$last_id_covered}]
    }
    set last_id_covered $right
}

puts $fresh_ids_count