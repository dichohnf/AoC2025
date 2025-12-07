#!/usr/bin/tclsh

set fp [open "input" r]
set file_text [read $fp]
close $fp
set lines [split $file_text "\n"]

set count 0
for {set row 1} {$row<[llength $lines]} {incr row} {
    set prev_line [lindex $lines [expr $row - 1]]
    set line [lindex $lines $row]
    for {set col 0} {$col<[string length $line]} {incr col} {
        set char [string index $line $col]
        set prev_line_char [string index $prev_line $col]
        if {$char eq "^"} {
            if {$prev_line_char eq "|"} {
                set line [string replace $line [expr $col - 1] [expr $col - 1] |]
                set line [string replace $line [expr $col + 1] [expr $col + 1] |]
                set lines [lreplace $lines $row $row $line]
                incr count
            }
            continue
        }
        if {[lsearch -exact {S |} $prev_line_char] >= 0 } {
            set line [string replace $line $col $col |]
            set lines [lreplace $lines $row $row $line]
        }
    }
}

foreach line $lines {
    puts $line
}
puts $count