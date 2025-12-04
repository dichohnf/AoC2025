#!/usr/bin/tclsh

proc check_at {line col} {
    set c [string index $line $col]
    if {$c eq "@"} {
        return 1
    }
    return 0
}

proc column_work {line col} {
    set lastIndex [expr {[string length $line] - 1}]
    switch $col {
        0 {
            return [expr {[check_at $line $col] + [check_at $line [expr {$col+1}]]}]
        }
        $lastIndex {
            return [expr {[check_at $line [expr {$col-1}]] + [check_at $line $col]}]
        }
        default {
            return [expr {[check_at $line [expr {$col-1}]] + [check_at $line $col] + [check_at $line [expr {$col+1}]]}]
        }
    }
}

set fp [open "input" r]
set file_text [read $fp]
close $fp
set lines [split $file_text "\n"]

set total 0
set removed -1
while {$removed} {
    set removed 0
    set last_row [expr {[llength $lines] - 1}]
    for {set row 0} {$row < [llength $lines]} {incr row} {
        set line [lindex $lines $row]
        for {set col 0} {$col < [string length $line]} {incr col} {
            set val [string index $line $col]
            if {$val eq "@"} {
                set count 0
                switch $row {
                    0 {
                        incr count [column_work $line $col]
                        set post_line [lindex $lines [expr {$row+1}]]
                        incr count [column_work $post_line $col]
                    }
                    $last_row {
                        set prev_line [lindex $lines [expr {$row-1}]]
                        incr count [column_work $prev_line $col]
                        incr count [column_work $line $col]
                    }
                    default {
                        set prev_line [lindex $lines [expr {$row-1}]]
                        incr count [column_work $prev_line $col]
                        incr count [column_work $line $col]
                        set post_line [lindex $lines [expr {$row+1}]]
                        incr count [column_work $post_line $col]
                    }
                }

                if {$count<5} {
                    incr removed
                    set lines [lreplace $lines $row $row [string replace $line $col $col .]]
                    set line [lindex $lines $row]
                }
            }
        }
    }
    incr total $removed
}

puts $total
