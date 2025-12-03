#!/usr/bin/tclsh

set fp [open "input" r]
set file_text [read $fp]
close $fp
set lines [split $file_text "\n"]

set sum 0
foreach line $lines {
    set left_value [string index $line [expr {[string length $line]-2}]]
    set right_value [string index $line [expr {[string length $line]-1}]]
    for {set idx [expr {[string length $line]-3}]} {$idx>=0} {incr idx -1} {
        set val [string index $line $idx]
        if {$val>=$left_value} {
            if {$left_value >= $right_value} {
                set right_value $left_value
                set left_value $val
            } else {
                set left_value $val
            }
        }
    }
    set line_result $left_value$right_value
    incr sum $line_result
    puts [format "%s\t%s" $line_result $line]
}
puts $sum