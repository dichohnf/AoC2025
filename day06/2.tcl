#!/usr/bin/tclsh

set fp [open "input" r]
set file_text [read $fp]
close $fp
set lines [split $file_text "\n"]

set operations [lindex $lines end]

set columns {}
foreach line [lrange $lines 0 end-1] {
    for {set col 0} {$col<[string length $line]} {incr col} {
        set column [lindex $columns $col]
        set char [string index $line $col]
        if {$char != " "} {
            set column $column$char
        }
        set columns [lreplace $columns $col $col $column]
    }
}

set idx 0
foreach operation $operations {
    set operands {}

    while 1 {
        set val [lindex $columns $idx]
        if {$val eq ""} {
            lappend results [expr [join $operands $operation]]
            set operation [lindex $operations $idx]
            incr idx
            break
        }
        lappend operands $val
        incr idx
    }
}

puts [format "Final result: %s" [expr [join $results +]]]