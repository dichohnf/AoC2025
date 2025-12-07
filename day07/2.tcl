#!/usr/bin/tclsh

proc new_timeline {start_row col} {
    upvar lines lines cache cache
    puts [format "%d - %d" $start_row $col]
    if {[dict exists $cache "$start_row,$col"]} {
        return [dict get $cache "$start_row,$col"]
    }
    for {set row [expr $start_row + 1]} {$row<[llength $lines]} {incr row} {
        set line [lindex $lines $row]
        set char [string index $line $col]
        if {$char eq "^"} {
            set tl_prev [new_timeline $row [expr $col - 1]]
            dict set cache "$row,[expr $col - 1]" $tl_prev
            set tl_next [new_timeline $row [expr $col + 1]]
            dict set cache "$row,[expr $col + 1]" $tl_next
            return [expr $tl_prev + $tl_next]
        }
    }
    return 1
}

set fp [open "input" r]
set file_text [read $fp]
close $fp
set lines [split $file_text "\n"]

set timelines 0
set cache {}
set start_line [lindex $lines 0]
for {set col 0} {$col<[string length $start_line]} {incr col} {
    set start [string index $start_line $col]
    if {$start eq "S"} {
        set timelines [new_timeline 0 $col]
        break
    }
}

puts $timelines