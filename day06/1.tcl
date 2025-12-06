#!/usr/bin/tclsh

set fp [open "input" r]
set file_text [read $fp]
close $fp
set lines [split $file_text "\n"]

set results  [lindex $lines 0]
set operations [lindex $lines end]

foreach line [lrange $lines 1 end-1] {
    for {set col 0} {$col<[llength $line]} {incr col} {
        set ex_result [lindex $results $col]
        set operation [lindex $operations $col]
        set new_operand [lindex $line $col]
        puts [format "%-10s %s %-5s = %s" $ex_result $operation $new_operand [expr $ex_result $operation $new_operand]]
        set result [expr $ex_result $operation $new_operand]
        set results [lreplace $results $col $col $result]
    }
    puts -----------------------------------------------
}

puts [format "Final result: %s" [expr [join $results +]]]